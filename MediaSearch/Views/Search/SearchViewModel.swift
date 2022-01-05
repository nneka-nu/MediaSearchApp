//
//  SearchViewModel.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/3/22.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    typealias SearchInfo = (term: String, type: MediaType)
    typealias ImageInfo = (url: URL, data: Data)

    @Published var searchTerm = ""
    @Published var searchResults: [Media] = []
    @Published var noResultsFound = false
    @Published var imagesData: [URL: Data] = [:]
    @Published var showErrorAlert = false
    @Published var mediaType = MediaType.ebook {
        didSet {
            search()
        }
    }
    @Published var isFetching = false {
        didSet {
            if isFetching {
                noResultsFound = false
                searchResults = []
            }
        }
    }

    private var searchPublisher = PassthroughSubject<SearchInfo, Never>()
    private var subscriptions = Set<AnyCancellable>()
    private var requestSubscription: AnyCancellable?
    private var previousSearch: SearchInfo?

    var queryLimit: Int = 10
    var errorMessage: String?

    func search() {
        print("search() called", searchTerm, mediaType)
        guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let newSearch = (term: searchTerm, type: mediaType)
        if let prev = previousSearch,
           prev.term == newSearch.term,
           prev.type == newSearch.type {
            // duplicate search
            return
        }
        previousSearch = newSearch

        sendRequest()
    }
}

extension SearchViewModel {
    private func sendRequest() {
        isFetching = true
        let searchQuery = SearchQuery(term: searchTerm,
                                      media: mediaType,
                                      limit: queryLimit)
        let apiManager = APIManager<ITunesAPIResponse>(path: .search(searchQuery))

        requestSubscription = apiManager.send()
            .sink { [weak self] completion in
                self?.isFetching = false
                if case .failure(let error) = completion {
                    self?.handleSearchError(error)
                }
            } receiveValue: { [weak self] apiResponse in
                self?.handleSearchResults(apiResponse.results)
            }
    }

    private func sendImageRequest(url: URL) {
        guard imagesData[url] == nil else { return }

        let apiManager = APIManager<Void>(path: .image(url))
        apiManager.sendForImage()
            .sink { data in
                if !data.isEmpty {
                    self.imagesData[url] = data
                }
            }
            .store(in: &subscriptions)
    }

    private func handleSearchResults(_ results: [Media]) {
        guard results.count > 0 else {
            noResultsFound = true
            return
        }

        searchResults = results

        for result in results {
            sendImageRequest(url: result.imageUrl)
        }
    }

    private func handleSearchError(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
        // allow user to retry the same search if there was an error
        previousSearch = nil
    }
}
