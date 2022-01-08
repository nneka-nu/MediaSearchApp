//
//  APIManagerTests.swift
//  MediaSearchTests
//
//  Created by Nneka Udoh on 1/7/22.
//

import XCTest
import Combine
@testable import MediaSearch

class APIManagerTests: XCTestCase {
    var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
        subscriptions = nil
    }

    func testSend_withEbookQuery_ShouldReturnResults() throws {
        let mockResponse = MockResponse.ebook

        MockURLProtocol.requestHandler = { request in
            let data = try! JSONEncoder().encode(mockResponse)
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (data, response)
        }


        var error: String?
        var apiResponse: ITunesAPIResponse?
        let expectation = XCTestExpectation(description: #function)
        let apiManager = APIHelper.makeAPIManager(for: .search)

        apiManager.send()
            .sink { completion in
                if case .failure(let err) = completion {
                    error = err.localizedDescription
                }
                expectation.fulfill()
            } receiveValue: { value in
                apiResponse = value
            }
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 0.1)

        XCTAssertNil(error)
        XCTAssert(apiResponse?.results.count == 1)
        XCTAssertEqual(apiResponse?.results.first?.name, mockResponse.results.first?.trackName)
    }

    func testSend_With500StatusCode_ShouldThrowServerError() {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (Data(), response)
        }


        var error: String?
        var apiResponse: ITunesAPIResponse?
        let expectation = XCTestExpectation(description: #function)
        let apiManager = APIHelper.makeAPIManager(for: .search)

        apiManager.send()
            .sink { completion in
                if case .failure(let err) = completion {
                    error = err.localizedDescription
                }
                expectation.fulfill()
            } receiveValue: { value in
                apiResponse = value
            }
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 0.1)

        XCTAssertNotNil(error)
        XCTAssertNil(apiResponse)
        XCTAssertEqual(error, APIError.server.localizedDescription)
    }

}
