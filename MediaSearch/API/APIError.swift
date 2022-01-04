//
//  APIError.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

enum APIError: Error, LocalizedError {
    case urlRequest
    case network
    case server

    var errorDescription: String? {
        switch self {
        case .urlRequest:
            return "The request could not be completed."
        case .network:
            return
                """
                We could not connect to the network. \
                Please check your internet connection, or try again later.
                """
        case .server:
            return "We could not connect to the server."
        }
    }
}
