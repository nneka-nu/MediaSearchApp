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

// MARK: Sample Data for Media
extension Media {
    static let imageUrlData: [String] = [
        """
        https://is5-ssl.mzstatic.com/image/thumb/Publication1 \
        25/v4/0d/b4/db/0db4db25-4fc4-52f0-492c-95d3d3daec86/9780463068281 \
        .jpg/100x100bb.jpg
        """
    ]
    static let singleMedia = Media(
        id: "1436991868",
        name: "Run from Ruin",
        description:
        """
        They’re not undead; they’re just angry…  \
        The DataMind meditation app has revolutionized the world, \
        making people smarter, happier, and more productive. But a \
        programming glitch in the final update causes billions of \
        users to experience uncontrollable rage and aggression. \
        <br /><br />Nick, an ordinary high school senior in Fairbanks \
        Alaska, is suddenly thrust into this life or death arena. \
        He and his brother must escape the zombie-like hordes of \
        blood-thirsty maniacs and seek refuge north of the arctic \
        circle.<br /><br />The four-hundred-mile journey tests the \
        boys, their wits, and their trust in each other. They think \
        they’re fighting to stay alive; but little do they know, \
        they’re fighting to save mankind.
        """,
        type: .ebook,
        genres: ["Horror", "Books", "Fiction & Literature", "Sci-Fi & Fantasy"],
        price: "Free",
        imageUrl: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Publication125/v4/0d/b4/db/0db4db25-4fc4-52f0-492c-95d3d3daec86/9780463068281.jpg/100x100bb.jpg")!,
        previewUrl: nil,
        releaseDate: Date().addingTimeInterval(-1 * 3 * 365 * 24 * 60 * 60))
    static let sampleData: [Media] = (0...6).map { _ in Media.singleMedia }
}
