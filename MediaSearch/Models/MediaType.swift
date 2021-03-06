//
//  MediaType.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

enum MediaType: String {
    case ebook, movie, tvShow

    var title: String {
        switch self {

        case .ebook:
            return "Book"
        case .movie:
            return "Movie"
        case .tvShow:
            return "TV Show"
        }
    }

    var entity: String {
        switch self {
        case .ebook:
            return "ebook"
        case .movie:
            return "movie"
        case .tvShow:
            return "tvSeason"
        }
    }

    var id: String { self.rawValue }
}

extension MediaType: CaseIterable, Identifiable, Codable { }
