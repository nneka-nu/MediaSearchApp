//
//  Kind.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

enum Kind: String {
    case ebook
    case movie = "feature-movie"
    case tvShow = "tv-episode"

    var mediaType: MediaType {
        switch self {
        case .ebook:
            return MediaType.ebook
        case .movie:
            return MediaType.movie
        case .tvShow:
            return MediaType.tvShow
        }
    }
}
