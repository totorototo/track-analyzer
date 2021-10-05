//
//  File.swift
//
//
//

import Foundation

/// Define the potential error cases.
enum TrackError: Error {
    case emptyWayPoints
    case indicesOutOfBounds
}

struct Track {
    public let wayPoints: [WayPoint]

    public init(wayPoints: [WayPoint]) {
        self.wayPoints = wayPoints
    }

    func getLength() -> Double {
        let distance = wayPoints.enumerated().reduce(0.0) { accumulate, current in
            current.0 < wayPoints.count - 1 ? accumulate + current.1.calculateDistanceTo(to: wayPoints[current.0 + 1]) : accumulate
        }
        return distance
    }

    func getElevation() -> Elevation {
        let elevation = wayPoints.enumerated().reduce(into: Elevation(positive: 0.0, negative: 0.0)) { accumulate, current in
            if current.0 < wayPoints.count - 1 {
                let delta = current.1.calculateElevationTo(to: wayPoints[current.0 + 1])
                accumulate.negative += abs(delta.negative)
                accumulate.positive += delta.positive
            }
        }
        return elevation
    }

    func getArea() -> Result<Area, TrackError> {
        guard let firstWayPoint = wayPoints.first else {
            return .failure(TrackError.emptyWayPoints)
        }

        let initialArea = Area(minLongitude: firstWayPoint.longitude, minLatitude: firstWayPoint.latitude, maxLongitude: firstWayPoint.longitude, maxLatitude: firstWayPoint.longitude)
        let area = wayPoints.reduce(into: initialArea) { accumulate, current in
            accumulate.minLatitude = min(accumulate.minLatitude, current.latitude)
            accumulate.maxLatitude = max(accumulate.minLatitude, current.latitude)
            accumulate.minLongitude = min(accumulate.minLongitude, current.longitude)
            accumulate.maxLongitude = max(accumulate.maxLongitude, current.longitude)
        }
        return .success(area)
    }

    func getSection(start: Int, end: Int) -> Result<[WayPoint], TrackError> {
        guard start >= 0, start <= wayPoints.count, end >= 0, end <= wayPoints.count, start < end else {
            return .failure(TrackError.indicesOutOfBounds)
        }

        let slice = wayPoints[start ..< end]
        return .success(Array(slice))
    }
}
