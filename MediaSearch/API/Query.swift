//
//  Query.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

protocol Query {
    var toDictionary: [String: String] { get }
}
