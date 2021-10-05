@testable import TrackAnalyzer
import XCTest

final class ElevationTests: XCTestCase {
    func testElevationEquality() {
        let firstElevation = Elevation(positive: 10.0, negative: 10.0)
        let secondElevation = Elevation(positive: 10.0, negative: 10.0)

        let isEqual = firstElevation == secondElevation

        XCTAssertTrue(isEqual)
    }

    func testElevationSum() {
        var firstElevation = Elevation(positive: 10.0, negative: 10.0)
        let secondElevation = Elevation(positive: 10.0, negative: 10.0)

        let computedElevation = Elevation(positive: 20.0, negative: 20.0)

        firstElevation += secondElevation

        XCTAssertEqual(computedElevation, firstElevation)
    }
}
