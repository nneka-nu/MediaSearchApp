//
//  MediaListView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import SwiftUI

struct MediaListView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel

    var imageWidth: CGFloat = 90
    var imageHeight: CGFloat = 100

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchViewModel.searchResults) { item in
                    row(for: item)
                }
            }
            .padding([.leading, .bottom], 16)
        }
    }

    @ViewBuilder
    func row(for mediaItem: Media) -> some View {
        Section(footer: footer(for: mediaItem)) {
            HStack(alignment: .top, spacing: 24) {
                if let data = searchViewModel.imagesData[mediaItem.imageUrl],
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: imageWidth)
                } else {
                    Rectangle()
                        .fill(Color("GrayColor"))
                        .frame(width: imageWidth, height: imageHeight)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(mediaItem.name)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .fixedSize(horizontal: false, vertical: true)

                    Text(mediaItem.description.stripHTML())
                        .lineLimit(3)
                }
            }
            .padding()

            Divider()
                .onAppear {
                    if mediaItem == searchViewModel.searchResults.last {
                        searchViewModel.loadMore()
                    }
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

struct MediaListView_Previews: PreviewProvider {
    static let searchViewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.searchResults = Media.sampleData
        return viewModel
    }()

    static var previews: some View {
        MediaListView()
            .environmentObject(searchViewModel)

    }
}
