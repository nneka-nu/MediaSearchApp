//
//  SearchViewModel.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/3/22.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    typealias ImageInfo = (url: URL, data: Data)

    @Published var searchTerm = ""
    @Published var searchResults: [Media] = []
    @Published var noResultsFound = false
    @Published var imagesData: [URL: Data] = [:]
    @Published var showErrorAlert = false
    @Published var isLoadingMore = false
    @Published var isFetchingInitialResults = false
    @Published var mediaType = MediaType.ebook {
        didSet {
            search()
        }
    }

    private var subscriptions = Set<AnyCancellable>()
    private var requestSubscription: AnyCancellable?
    private var previousQuery: SearchQuery?
    private var resultIds: [String: String] = [:]
    private var loadingMoreComplete = false
    private var queryLimit: Int = 20

    var errorMessage: String?

    func search() {
        guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let newQuery = SearchQuery(term: searchTerm,
                                   media: mediaType,
                                   limit: queryLimit)

        if let previousQuery = previousQuery,
           previousQuery.term == newQuery.term,
           previousQuery.media == newQuery.media {
            // duplicate search
            return
        }

        resetSearch()
        previousQuery = newQuery
        sendRequest(with: newQuery)
    }

    func loadMore() {
        guard !loadingMoreComplete, searchResults.count >= queryLimit else {
            stopLoadingMore()
            return
        }

        isLoadingMore = true

        if var query = previousQuery {
            query.offset = searchResults.count
            previousQuery = query
            sendRequest(with: query)
            return
        }
    }
}

extension SearchViewModel {
    private func sendRequest(with query: SearchQuery) {
        if searchResults.count == 0 {
            isFetchingInitialResults = true
        }
        
        let apiManager = APIManager<ITunesAPIResponse>(path: .search(query))
        requestSubscription = apiManager.send()
            .sink { [weak self] completion in
                self?.isFetchingInitialResults = false
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
            if isLoadingMore {
                stopLoadingMore()
            } else {
                noResultsFound = true
            }
            return
        }

        // iTunes Search API often returns duplicates
        // remove duplicates by id.
        var newResults: [Media] = []

        for item in results where resultIds[item.id] != item.id {
            resultIds[item.id] = item.id
            newResults.append(item)
            sendImageRequest(url: item.imageUrl)
        }

        guard newResults.count > 0 else {
            if isLoadingMore {
                stopLoadingMore()
            }
            return
        }

        searchResults += newResults
    }

    private func handleSearchError(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
        isLoadingMore = false
        // allow user to retry the same search due to the error
        previousQuery = nil
    }

    private func resetSearch() {
        searchResults = []
        resultIds = [:]
        noResultsFound = false
        errorMessage = nil
        previousQuery = nil
        isLoadingMore = false
        loadingMoreComplete = false
    }

    private func stopLoadingMore() {
        isLoadingMore = false
        loadingMoreComplete = true
    }
}
