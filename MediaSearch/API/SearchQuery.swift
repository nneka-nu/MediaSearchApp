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
    var offset: Int = 0

    var toDictionary: [String: String] {
        return [
            "term": term,
            "media": media.rawValue,
            "limit": String(limit),
            "offset": String(offset)
        ]
    }
}
