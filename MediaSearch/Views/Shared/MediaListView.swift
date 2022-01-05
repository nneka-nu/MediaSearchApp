//
//  MediaListView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import SwiftUI

struct MediaListView: View {
    var mediaList: [Media]
    var imagesData: [URL: Data] = [:]
    var queryLimit: Int = 0
    var showProgressViewFooter = false

    var imageWidth: CGFloat = 90
    var imageHeight: CGFloat = 100

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(mediaList) { item in
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
                if let data = imagesData[mediaItem.imageUrl],
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: imageWidth)
                } else {
                    Rectangle()
                        .fill(Color(red: 204/255, green: 204/255, blue: 204/255))
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
                   // MARK: TODO lazy load next set of results here
//                    print("Divider \(index) appeared")
                }
        }
    }

    @ViewBuilder
    func footer(for mediaItem: Media) -> some View {
        if showProgressViewFooter && mediaList.count < queryLimit {
            EmptyView()
        } else if showProgressViewFooter && mediaItem == mediaList.last {
            HStack {
                Spacer()

                ProgressView("Loading")
                    .padding([.top, .bottom], 10)

                Spacer()
            }
        } else {
            EmptyView()
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView(mediaList: Media.sampleData, queryLimit: 10)
    }
}
