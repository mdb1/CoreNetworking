//
//  RequestTests.swift
//  
//
//  Created by Manu on 27/05/2023.
//

@testable import CoreNetworking
import XCTest

final class RequestTests: XCTestCase {
    func testGetPropertiesWithoutHeaders() throws {
        // Given
        let urlString = "https://catfact.ninja"
        let sut = Request(urlString: urlString, method: .get([]), headers: [:])
        let props = sut.logProperties

        // Then
        let dictURL = try XCTUnwrap(props["URL"] as? String)
        XCTAssertTrue(dictURL.contains(urlString))
        XCTAssertEqual(props["HTTP Method"] as? String, "GET")
        XCTAssertNotNil(props["Request's Internal Id"])
        XCTAssertNil(props["HTTP Headers"])
        XCTAssertNil(props["HTTP Body"])
    }

    func testGetPropertiesWithHeaders() throws {
        // Given
        let urlString = "https://catfact.ninja"
        let sut = Request(urlString: urlString, method: .get([]), headers: ["Content": "Hey"])
        let props = sut.logProperties

        // Then
        let dictURL = try XCTUnwrap(props["URL"] as? String)
        XCTAssertTrue(dictURL.contains(urlString))
        XCTAssertEqual(props["HTTP Method"] as? String, "GET")
        XCTAssertNotNil(props["Request's Internal Id"])
        let dictHeaders = try XCTUnwrap(props["HTTP Headers"] as? [String: String])
        XCTAssertEqual(dictHeaders.count, 1)
        XCTAssertEqual(dictHeaders["Content"], "Hey")
        XCTAssertNil(props["HTTP Body"])
    }

    func testPostPropertiesWithHeaders() throws {
        // Given
        let urlString = "https://catfact.ninja"
        let sut = Request(urlString: urlString, method: .post(Data()), headers: ["Content": "Hey"])
        let props = sut.logProperties

        // Then
        let dictURL = try XCTUnwrap(props["URL"] as? String)
        XCTAssertTrue(dictURL.contains(urlString))
        XCTAssertEqual(props["HTTP Method"] as? String, "POST")
        XCTAssertNotNil(props["Request's Internal Id"])
        let dictHeaders = try XCTUnwrap(props["HTTP Headers"] as? [String: String])
        XCTAssertEqual(dictHeaders.count, 1)
        XCTAssertEqual(dictHeaders["Content"], "Hey")
        XCTAssertNotNil(props["HTTP Body"])
    }

    func testPatchPropertiesWithHeaders() throws {
        // Given
        let urlString = "https://catfact.ninja"
        let sut = Request(urlString: urlString, method: .patch, headers: ["Content": "Hey"])
        let props = sut.logProperties

        // Then
        let dictURL = try XCTUnwrap(props["URL"] as? String)
        XCTAssertTrue(dictURL.contains(urlString))
        XCTAssertEqual(props["HTTP Method"] as? String, "PATCH")
        XCTAssertNotNil(props["Request's Internal Id"])
        let dictHeaders = try XCTUnwrap(props["HTTP Headers"] as? [String: String])
        XCTAssertEqual(dictHeaders.count, 1)
        XCTAssertEqual(dictHeaders["Content"], "Hey")
        XCTAssertNil(props["HTTP Body"])
    }

    func testPutPropertiesWithHeaders() throws {
        // Given
        let urlString = "https://catfact.ninja"
        let sut = Request(urlString: urlString, method: .put(Data()), headers: ["Content": "Hey"])
        let props = sut.logProperties

        // Then
        let dictURL = try XCTUnwrap(props["URL"] as? String)
        XCTAssertTrue(dictURL.contains(urlString))
        XCTAssertEqual(props["HTTP Method"] as? String, "PUT")
        XCTAssertNotNil(props["Request's Internal Id"])
        let dictHeaders = try XCTUnwrap(props["HTTP Headers"] as? [String: String])
        XCTAssertEqual(dictHeaders.count, 1)
        XCTAssertEqual(dictHeaders["Content"], "Hey")
        XCTAssertNotNil(props["HTTP Body"])
    }
}
