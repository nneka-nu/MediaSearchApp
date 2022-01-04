//
//  MediaListView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import SwiftUI

struct MediaListView: View {
    var media: [Media]
    var showProgressViewFooter = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<media.count) {index in
                    row(index: index)
                }
            }
            .padding([.leading, .bottom], 16)
        }
    }

    func row(index: Int) -> some View {
        Section(footer: footer(at: index)) {
            HStack(alignment: .top, spacing: 24) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 66, height: 100)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(media[index].name)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(media[index].description.stripHTML())
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
    func footer(at index: Int) -> some View {
        if (showProgressViewFooter && index == media.endIndex - 1) {
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
        MediaListView(media: Media.sampleData)
    }
}
