//
//  APIManager.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

struct APIManager<Response>: APIRequest {
    var path: Path
    var urlSession: URLSession = .shared
}
