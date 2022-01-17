//
//  FavoritesSummaryView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import SwiftUI
import CoreData

struct FavoritesSummaryView: View {
    @FetchRequest private var favorites: FetchedResults<FavoriteMedia>
    private var rows: [GridItem] = Array(
        repeating: .init(.fixed(45), spacing: 20, alignment: .leading),
        count: 3
    )

    init() {
        let request = FavoriteMedia.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMedia.id, ascending: true)]
        request.fetchLimit = 1
        _favorites = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        if favorites.count == 0 {
            Text("No favorites found.")
        } else {
            ScrollView(showsIndicators: false) {
                FavoritesSummaryGridView(rows: rows, type: .ebook)
                FavoritesSummaryGridView(rows: rows, type: .movie)
                FavoritesSummaryGridView(rows: rows, type: .tvShow)
            }
        }
    }
}

struct FavoritesSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesSummaryView()
            .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
    }
}
