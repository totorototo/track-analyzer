
/// Define the potential error cases.
enum AnalyzerError: Error {
    case emptyPoints
    case indicesOutOfBounds
    case pointNotFound
    case pointIndexNotFound
    case negativeDistance
    case internalError
    case outOfBounds
}

public struct Analyzer {
    struct Statistic {
        public let distance: Double
        public let elevation: Elevation
    }

    public let track: Track
    private let statistics: [Statistic]

    public init(track: Track) {
        self.track = track
        statistics = Analyzer.computeStatistics(track: track)
    }

    static func computeStatistics(track: Track) -> [Statistic] {
        let initialStatistic = Statistic(distance: 0.0, elevation: Elevation(positive: 0.0, negative: 0.0))
        var cumulativeDistance = 0.0
        var cumulativeElevation = Elevation(positive: 0.0, negative: 0.0)

        let statistics = track.wayPoints.enumerated().reduce(into: [initialStatistic]) { accumulated, current in
            if current.0 < track.wayPoints.count - 1 {
                let nextPoint = track.wayPoints[current.0 + 1]
                let distance = current.1.calculateDistanceTo(to: nextPoint)
                let elevation = current.1.calculateElevationTo(to: nextPoint)

                cumulativeDistance += distance
                cumulativeElevation += elevation

                let currentStatistic = Statistic(distance: cumulativeDistance, elevation: cumulativeElevation)
                accumulated.append(currentStatistic)
            }
        }

        return statistics
    }

    func findClosestPoint(currentPoint: WayPoint) -> Result<WayPoint, AnalyzerError> {
        guard let firstPoint = track.wayPoints.first else {
            return .failure(.emptyPoints)
        }

        let point = track.wayPoints.reduce(firstPoint) { accumulate, current in
            let referenceDistance = current.calculateDistanceTo(to: accumulate)
            let newDistance = current.calculateDistanceTo(to: currentPoint)
            return newDistance < referenceDistance ? current : accumulate
        }
        return .success(point)
    }

    func findPointIndex(currentPoint: WayPoint) -> Result<Int, AnalyzerError> {
        guard let index = track.wayPoints.firstIndex(where: { $0 == currentPoint }) else {
            return .failure(.pointIndexNotFound)
        }
        return .success(index)
    }

    func findPointIndexAt(distance: Double) -> Result<Int, AnalyzerError> {
        guard distance >= 0.0 else {
            return .failure(.negativeDistance)
        }

        guard let firstStatistic = statistics.first else {
            return .failure(.emptyPoints)
        }

        let initialDistance = firstStatistic.distance
        var delta = abs(distance - initialDistance)

        let index = statistics.enumerated().reduce(0) { accumulate, current in
            let diff = abs(distance - current.1.distance)
            if diff < delta {
                delta = diff
                return current.0
            }
            return accumulate
        }
        return .success(index)
    }

    func findPointAt(distance: Double) -> Result<WayPoint, AnalyzerError> {
        let index = findPointIndexAt(distance: distance)
        switch index {
        case let .success(id):
            return .success(track.wayPoints[id])
        case .failure:
            return .failure(.pointNotFound)
        }
    }

    func getTraceSection(start: Double, end: Double) -> Result<[WayPoint], AnalyzerError> {
        guard let lastStatistics = statistics.last else {
            return .failure(.internalError)
        }

        guard lastStatistics.distance >= end, end >= 0, start >= 0, start <= lastStatistics.distance, start < end else {
            return .failure(.outOfBounds)
        }
        let startIndex = findPointIndexAt(distance: start)
        let endIndex = findPointIndexAt(distance: end)

        switch (startIndex, endIndex) {
        case let (.success(startId), .success(endId)):
            let result = track.getSection(start: startId, end: endId).mapError { (_) -> AnalyzerError in
                AnalyzerError.internalError
            }
            switch result {
            case let .success(points):
                return .success(points)
            case let .failure(error):
                return .failure(error)
            }
        case (.failure(_), _):
            return .failure(.outOfBounds)
        case (_, .failure(_)):
            return .failure(.outOfBounds)
        }
    }
}
