//
//  APIHelper.swift
//  MediaSearchTests
//
//  Created by Nneka Udoh on 1/7/22.
//

import XCTest
@testable import MediaSearch

enum Request {
    case search
    case lookup
}

struct APIHelper {
    static var urlSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
    
    static func makeAPIManager(for request: Request) -> APIManager<ITunesAPIResponse> {
        switch request {
        case .search:
            let searchQuery = SearchQuery(term: "term", media: .ebook)
            return APIManager<ITunesAPIResponse>(
                path: .search(searchQuery),
                urlSession: urlSession
            )
        case .lookup:
            let lookupQuery = LookupQuery(id: "456789")
            return APIManager<ITunesAPIResponse>(
                path: .lookup(lookupQuery),
                urlSession: urlSession
            )
        }
    }

    static func makeAPIManagerForImage() -> APIManager<Void> {
        let url = URL(string: "https://")!
        return APIManager<Void>(path: .image(url), urlSession: urlSession)
    }
}
