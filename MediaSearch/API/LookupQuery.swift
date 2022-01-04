//
//  LookupQuery.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

struct LookupQuery: Query {
    var id: String

    var toDictionary: [String: String] {
        return [
            "id": id
        ]
    }
}
