//
//  MockURLProtocol.swift
//  MediaSearchTests
//
//  Created by Nneka Udoh on 1/7/22.
//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (Data, URLResponse))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let requestHandler = MockURLProtocol.requestHandler else {
            XCTFail("A request handler is required.")
            return
        }

        do {
            let (data, response) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // required
    }
}
