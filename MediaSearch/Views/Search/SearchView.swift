//
//  SearchView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/3/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchViewModel = SearchViewModel()

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
            .disabled(searchViewModel.isFetching)
            .pickerStyle(SegmentedPickerStyle())

            MediaListView()

        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
