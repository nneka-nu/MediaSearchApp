//
//  FavoritesSummaryGridView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import SwiftUI

struct FavoritesSummaryGridView: View {
    @FetchRequest
    private var favorites: FetchedResults<FavoriteMedia>
    var rows: [GridItem]
    var type: MediaType

    init(rows: [GridItem], type: MediaType) {
        self.rows = rows
        self.type = type

        let request = FavoriteMedia.fetchRequest()
        request.fetchLimit = 10
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMedia.createdAt, ascending: false)]
        request.predicate = NSPredicate(format: "type == %@", type.rawValue)
        _favorites = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        VStack {
            if favorites.count > 0 {
                HStack {
                    Text("\(type.title)s")
                    Spacer()
                    NavigationLink("View All") {
                        Text("Destination \(type.rawValue)")
                    }
                }
                .padding([.leading, .trailing], 16)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .top) {
                    ForEach(favorites.grouped(by: 3), id: \.self) { item in
                        if item.count >= 1 {
                            GridItemLinkView(item: item[0])
                        }
                        if item.count >= 2 {
                            GridItemLinkView(item: item[1])
                        }
                        if item.count == 3 {
                            GridItemLinkView(item: item[2])
                        }
                    }
                }
            }
            .padding([.leading], 16)

            Spacer()
        }
        .padding(.bottom, 24)
    }

}

struct FavoritesSummaryGridView_Previews: PreviewProvider {
    static let rows: [GridItem] = Array(
        repeating: .init(.fixed(45), spacing: 20, alignment: .leading),
        count: 3
    )
    
    static var previews: some View {
        FavoritesSummaryGridView(rows: rows, type: .ebook)
            .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
    }
}
