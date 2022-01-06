//
//  SearchView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/3/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            SearchBar(text: $searchViewModel.searchTerm) {
                searchViewModel.search()
            }

            Picker("", selection: $searchViewModel.mediaType) {
                ForEach(MediaType.allCases) { section in
                    Text(section.title).tag(section)
                }
            }
            .disabled(searchViewModel.isFetchingInitialResults)
            .pickerStyle(SegmentedPickerStyle())

            ZStack {
                MediaListView()
                    .environmentObject(searchViewModel)
                
                if searchViewModel.isFetchingInitialResults {
                    ProgressView()
                }

                if searchViewModel.noResultsFound {
                    Text("No results found.")
                        .bold()
                }
            }
        }
        .alert(isPresented: $searchViewModel.showErrorAlert) {
            let message = searchViewModel.errorMessage
            searchViewModel.errorMessage = nil

            return Alert(
                title: Text("Error"),
                message: Text(message ?? APIError.generic.localizedDescription)
            )
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
