//
//  HTTPURLResponseTests.swift
//  
//
//  Created by Manu on 27/05/2023.
//

@testable import CoreNetworking
import XCTest

final class HTTPURLResponseTests: XCTestCase {
    func testResponseProperties() throws {
        // Given
        let urlString = "https://catfact.ninja"
        let sut = HTTPURLResponse(url: URL(string: urlString)!, statusCode: 200, httpVersion: "", headerFields: nil)!
        let props = sut.logProperties

        // Then
        let dictURL = try XCTUnwrap(props["URL"] as? String)
        XCTAssertTrue(dictURL.contains(urlString))
        XCTAssertEqual(props["Status Code"] as? String, "200")
    }
}
