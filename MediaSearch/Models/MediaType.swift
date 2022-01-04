//
//  MediaType.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

enum MediaType: String, CaseIterable, Identifiable {
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

    var id: String { self.rawValue }
}
