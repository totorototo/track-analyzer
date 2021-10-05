@testable import TrackAnalyzer
import XCTest

final class AreaTests: XCTestCase {
    func testAreasAreEqual() throws {
        let firstArea = Area(minLongitude: 2.350987, minLatitude: 48.856667, maxLongitude: 6.350987, maxLatitude: 55.755787)

        let secondArea = Area(minLongitude: 2.350987, minLatitude: 48.856667, maxLongitude: 6.350987, maxLatitude: 55.755787)

        XCTAssertTrue(firstArea == secondArea)
    }
}
