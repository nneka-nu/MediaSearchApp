//
//  MockResponse.swift
//  MediaSearchTests
//
//  Created by Nneka Udoh on 1/7/22.
//

import Foundation

struct MockResponse: Encodable {
    var results: [MockMedia]

    static var ebook: MockResponse {
        MockResponse(results: [MockMedia()])
    }
}

struct MockMedia: Encodable {
    var trackId: Int = 1
    var trackName = "Alice in Wonderland"
    var collectionName = "Alice in Wonderland"
    var description = "Description for Alice in Wonderland"
    var longDescription = "Long Description for Alice in Wonderland"
    var kind = "ebook"
    var genres: [String] = ["Action", "Adventure", "Fantasy"]
    var formattedPrice = "$1.99"
    var artworkUrl100 = "https://image.jpg"
    var previewUrl: String? = nil
    var releaseDate = Date().addingTimeInterval(10 * 365 * 24 * 60 * 60).ISO8601Format()
}
