import XCTest
@testable import ExtendedError

final class ExtendedErrorTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(Terminate(.badRequest, code: ".errorInCode").code, ".errorInCode")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
