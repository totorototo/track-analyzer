@testable import TrackAnalyzer
import XCTest

final class TrackAnalyzerTests: XCTestCase {
    func testFindClosestPoint() {
        let paris = WayPoint(longitude: 2.350987, latitude: 48.856667, altitude: 0.0)
        let moscow = WayPoint(longitude: 37.617634, latitude: 55.755787, altitude: 200.0)
        let wayPoints = [paris, moscow]
        let currentPoint = WayPoint(longitude: 1.350987, latitude: 49.856667, altitude: 800.0)

        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)

        let closestPoint = analyzer.findClosestPoint(currentPoint: currentPoint)

        XCTAssertEqual(closestPoint, .success(paris))
    }

    func testFindClosestPointReturnsError() {
        let wayPoints: [WayPoint] = []
        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)
        let currentPoint = WayPoint(longitude: 1.350987, latitude: 49.856667, altitude: 800.0)

        let closestPoint = analyzer.findClosestPoint(currentPoint: currentPoint)

        XCTAssertEqual(closestPoint, .failure(AnalyzerError.emptyPoints))
    }

    func testFindPointIndexShouldReturnsIndex() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)
        let currentPoint = WayPoint(longitude: 0.313988, latitude: 42.824213, altitude: 814.00)
        let analyzer = Analyzer(track: track)

        let index = analyzer.findPointIndex(currentPoint: currentPoint)

        XCTAssertEqual(index, .success(30))
    }

    func testFindPointIndexShouldReturnsError() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)
        let currentPoint = WayPoint(longitude: 0.313988, latitude: 42.824214, altitude: 814.00)
        let analyzer = Analyzer(track: track)

        let index = analyzer.findPointIndex(currentPoint: currentPoint)

        XCTAssertEqual(index, .failure(AnalyzerError.pointIndexNotFound))
    }

    func testFindPointIndexAtShouldReturnsIndex() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)

        let index = analyzer.findPointIndexAt(distance: 0.4)

        XCTAssertEqual(index, .success(5))
    }

    func testFindPointIndexAtShouldReturnsNilForNegativeDistance() throws {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)

        let index = analyzer.findPointIndexAt(distance: -0.4)

        XCTAssertEqual(index, .failure(AnalyzerError.negativeDistance))
    }

    func testFindPointAtShouldReturnsPoint() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)
        let matchedPoint = WayPoint(longitude: 0.328684, latitude: 42.828782, altitude: 793.0)

        let point = analyzer.findPointAt(distance: 0.2)

        XCTAssertEqual(point, .success(matchedPoint))
    }

    func testFindPointAtShouldReturnsError() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)

        let point = analyzer.findPointAt(distance: -10.2)

        XCTAssertEqual(point, .failure(AnalyzerError.pointNotFound))
    }

    func testGetTraceSection() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let sectionPoints = wayPoints[..<6]
        let computedSection = Array(sectionPoints)

        let track = Track(wayPoints: wayPoints)
        let analyzer = Analyzer(track: track)

        let section = analyzer.getTraceSection(start: 0.0, end: 0.6)

        XCTAssertEqual(section, .success(computedSection))
    }
}
