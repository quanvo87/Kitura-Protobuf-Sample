import XCTest
@testable import protocolbuffer_fun

class protocolbuffer_funTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(protocolbuffer_fun().text, "Hello, World!")
    }


    static var allTests : [(String, (protocolbuffer_funTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
