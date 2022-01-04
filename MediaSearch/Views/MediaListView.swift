//
//  MediaListView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import SwiftUI

struct MediaListView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<11) {val in
                    rowView(index: val)
                }
            }
            .padding([.leading, .bottom], 16)
        }
    }

    func rowView(index: Int) -> some View {
        Section(footer: footerView(at: index)) {
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 66, height: 100)
                
                VStack {
                    Text("Name:")
                    Text("Desc:")
                }
            }
            .padding()

            Divider()
        }
    }

    @ViewBuilder
    func footerView(at index: Int) -> some View {
        if (index == 10) {
            HStack(alignment: .center) {
                Spacer()

                Button("Load More \(index)") {
                    print("Load More")
                }

                Spacer()
            }
            .padding()
        } else {
            EmptyView()
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView()
    }
}
