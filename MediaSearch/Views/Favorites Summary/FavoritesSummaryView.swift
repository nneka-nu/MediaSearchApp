//
//  FavoritesSummaryView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import SwiftUI

struct FavoritesSummaryView: View {
    @FetchRequest
    private var ebookFavorites: FetchedResults<FavoriteMedia>

    init() {
        let request = FavoriteMedia.fetchRequest()
        request.fetchLimit = 7
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMedia.createdAt, ascending: false)]
        request.predicate = NSPredicate(format: "type == %@", MediaType.ebook.rawValue)
        _ebookFavorites = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        List(ebookFavorites) { media in
            Text("\(media.title) \(media.type)")
        }
    }
}

struct FavoritesSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesSummaryView()
            .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
    }
}
