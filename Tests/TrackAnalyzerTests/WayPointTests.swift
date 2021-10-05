//
//  File.swift
//
//
//

@testable import TrackAnalyzer
import XCTest

final class WayWayPointTests: XCTestCase {
    func testDistanceBetweenTwoWayPoints() {
        let paris = WayPoint(longitude: 2.350987, latitude: 48.856667, altitude: 0.0)
        let moscow = WayPoint(longitude: 37.617634, latitude: 55.755787, altitude: 0.0)

        let distance = paris.calculateDistanceTo(to: moscow)

        XCTAssertEqual(distance, 2486.340992526076)
    }

    func testBearingBetweenTwoWayPoints() {
        let paris = WayPoint(longitude: 2.350987, latitude: 48.856667, altitude: 0.0)
        let moscow = WayPoint(longitude: 37.617634, latitude: 55.755787, altitude: 0.0)

        let bearing = paris.calculateBearingTo(to: moscow)

        XCTAssertEqual(bearing, 58.65519236183434)
    }

    func testWayPointIsInArea() {
        let paris = WayPoint(longitude: 2.350987, latitude: 48.856667, altitude: 0.0)
        let area = Area(minLongitude: 36.617634, minLatitude: 54.755787, maxLongitude: 38.617634, maxLatitude: 56.755787)

        let isIn = paris.isInArea(area: area)

        XCTAssertFalse(isIn)
    }

    func testWayPointIsInRadius() {
        let center = WayPoint(
            longitude: 6.23828,
            latitude: 45.50127,
            altitude: 0.0
        )
        let location = WayPoint(
            longitude: 5.77367,
            latitude: 45.07122,
            altitude: 0.0
        )

        let radius = 70000.00
        let isIn = location.isInRadius(centerWayPoint: center, radius: radius)

        XCTAssertTrue(isIn)
    }

    func testElevationToWayPoint() {
        let paris = WayPoint(longitude: 2.350987, latitude: 48.856667, altitude: 0.0)
        let moscow = WayPoint(longitude: 37.617634, latitude: 55.755787, altitude: 200.0)

        let elevation = paris.calculateElevationTo(to: moscow)

        XCTAssertEqual(elevation.positive, 200.0)
        XCTAssertEqual(elevation.negative, 0.0)
    }
}
