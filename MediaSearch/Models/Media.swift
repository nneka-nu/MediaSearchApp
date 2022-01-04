//
//  Media.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

struct Media {
    var id: String
    var name: String
    var description: String
    var type: MediaType
    var genres: [String]
    var price: String
    var imageUrl: URL
    var previewUrl: URL?
    var releaseDate: Date
}

extension Media: Codable {
    enum CodingKeys: String, CodingKey {
        case genres, releaseDate, description, previewUrl
        case id = "trackId"
        case name = "trackName"
        case type = "kind"
        case price = "formattedPrice"
        case imageUrl = "artworkUrl100"
    }

    enum AdditionalKeys: String, CodingKey {
        case longDescription
        case primaryGenreName
        case trackPrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .id))
        name = try container.decode(String.self, forKey: .name)

        let kind = try container.decode(String.self, forKey: .type)
        if let mediaKind = Kind(rawValue: kind) {
            type = mediaKind.mediaType
        } else {
            type = .ebook
        }

        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        previewUrl = (try? container.decode(URL.self, forKey: .previewUrl)) ?? nil
        releaseDate = try container.decode(Date.self, forKey: .releaseDate)

        let additionalContainer = try decoder.container(keyedBy: AdditionalKeys.self)

        if let description = try? container.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            description = (try? additionalContainer.decode(String.self, forKey: .longDescription)) ?? "No description"
        }

        if let genres = try? container.decode([String].self, forKey: .genres) {
            self.genres = genres
        } else if let genre = try? additionalContainer.decode(String.self, forKey: .primaryGenreName) {
            genres = [genre]
        } else {
            genres = []
        }

        if let price = try? container.decode(String.self, forKey: .price) {
            self.price = price
        } else if let price = try? additionalContainer.decode(String.self, forKey: .trackPrice) {
            self.price = price
        } else if let number = (try? additionalContainer.decode(Double.self, forKey: .trackPrice)) {
            self.price = "$\(number)"
        } else {
            price = ""
        }
    }
}

//extension Media {
//    static let sampleData: [Media] = [
//        Media(id: <#T##String#>,
//              name: <#T##String#>,
//              description: <#T##String#>,
//              type: <#T##MediaType#>,
//              genres: <#T##[String]#>,
//              price: <#T##String#>,
//              imageUrl: <#T##URL#>,
//              previewUrl: <#T##URL?#>,
//              releaseDate: <#T##Date#>)
//    ]
//}
