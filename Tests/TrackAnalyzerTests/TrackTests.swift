//
//  File.swift
//
//
//

@testable import TrackAnalyzer
import XCTest

final class trackTests: XCTestCase {
    func testGetTrackLength() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let trace = Track(wayPoints: wayPoints)
        let distance = trace.getLength()

        XCTAssertEqual(distance, 25.387273692311354)
    }

    func testGetTraceElevation() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let trace = Track(wayPoints: wayPoints)
        let elevation = trace.getElevation()

        XCTAssertEqual(elevation.positive, 1785.0)
        XCTAssertEqual(elevation.negative, 1418.0)
    }

    func testGetArea() {
        let paris = WayPoint(longitude: 2.350987, latitude: 48.856667, altitude: 0.0)
        let moscow = WayPoint(longitude: 37.617634, latitude: 55.755787, altitude: 200.0)
        let computedArea = Area(minLongitude: 2.350987, minLatitude: 48.856667, maxLongitude: 37.617634, maxLatitude: 55.755787)

        let wayPoints = [paris, moscow]
        let trace = Track(wayPoints: wayPoints)

        let area = trace.getArea()

        XCTAssertEqual(area, .success(computedArea))
    }

    func testGetAreaShouldReturnsError() {
        let wayPoints: [WayPoint] = []
        let track = Track(wayPoints: wayPoints)

        let area = track.getArea()

        XCTAssertEqual(area, .failure(TrackError.emptyWayPoints))
    }

    func testGetSectionShouldReturnsSection() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let sectionPoints = wayPoints[..<4]
        let computedSection = Array(sectionPoints)

        let track = Track(wayPoints: wayPoints)

        let section = track.getSection(start: 0, end: 4)
        XCTAssertEqual(section, .success(computedSection))
    }

    func testGetSectionShouldReturnsError() {
        let wayPoints = mockedData.map { (item) -> WayPoint in
            WayPoint(longitude: item[0], latitude: item[1], altitude: item[2])
        }

        let track = Track(wayPoints: wayPoints)

        let section = track.getSection(start: 0, end: 11115)
        XCTAssertEqual(section, .failure(TrackError.indicesOutOfBounds))
    }
}
