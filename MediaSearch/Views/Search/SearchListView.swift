//
//  SearchListView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import SwiftUI

struct SearchListView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State var selectedItem: (Media, Data)? = nil

    var body: some View {
        Group {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(searchViewModel.searchResults) { item in
                        row(for: item)
                    }
                }
                .padding([.all], 16)
            }

            NavigationLink(isActive: $searchViewModel.isLinkActive) {
                if let item = selectedItem {
                    MediaDetailView(media: item.0, imageData: item.1)
                }
            } label: {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    func row(for mediaItem: Media) -> some View {
        Section(footer: footer(for: mediaItem)) {
            Button {
                selectedItem = (mediaItem,
                                searchViewModel.imagesData[mediaItem.imageUrl] ?? Data())
                searchViewModel.isLinkActive = true

            } label: {
                rowContent(for: mediaItem)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(height: 130)

            Divider()
                .onAppear {
                    if mediaItem == searchViewModel.searchResults.last {
                        searchViewModel.loadMore()
                    }
                }
        }
    }

    func rowContent(for mediaItem: Media) -> some View {
        HStack(alignment: .top, spacing: 24) {
            if let data = searchViewModel.imagesData[mediaItem.imageUrl],
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100)
            } else {
                ImagePlaceholderView()
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(mediaItem.name)
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)

                Text(mediaItem.description.stripHTML())
                    .lineLimit(3)
            }
        }
    }

    @ViewBuilder
    func footer(for mediaItem: Media) -> some View {
        if searchViewModel.isLoadingMore,
           mediaItem == searchViewModel.searchResults.last {
            HStack {
                Spacer()

                ProgressView("Loading...")
                    .padding([.top, .bottom], 10)

                Spacer()
            }
        }  else {
            EmptyView()
        }
    }
}

struct SearchListView_Previews: PreviewProvider {
    static let searchViewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.searchResults = Media.sampleData
        return viewModel
    }()

    static var previews: some View {
        SearchListView()
            .environmentObject(searchViewModel)

    }
}
