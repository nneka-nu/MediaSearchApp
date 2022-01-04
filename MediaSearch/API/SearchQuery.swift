//
//  SearchQuery.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

struct SearchQuery: Query {
    var term: String
    var media: MediaType
    var limit: Int = 10

    var toDictionary: [String: String] {
        print("toDictionary media.rawValue", media.rawValue)
        return [
            "term": term,
            "media": media.rawValue,
            "limit": String(limit)
        ]
    }
}
