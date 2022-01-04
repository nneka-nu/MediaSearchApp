//
//  SearchViewModel.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/3/22.
//

import Foundation

class SearchViewModel: NSObject, ObservableObject, URLSessionTaskDelegate {
    @Published var searchTerm = ""
    @Published var mediaType = MediaType.ebook
    @Published var isFetching = false
    @Published var searchResults: [Media] = Media.sampleData
    @Published var noResultsFound = false

    func search() {
        print("search()...", searchTerm)
    }
}
