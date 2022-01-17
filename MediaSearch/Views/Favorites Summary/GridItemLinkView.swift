//
//  GridItemLinkView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import SwiftUI

struct GridItemLinkView: View {
    var item: FavoriteMedia

    var body: some View {
        NavigationLink {
            Text("Detail \(item.id)")
        } label: {
            FavoritesSummaryGridItemView(text: item.title)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GridItemLinkView_Previews: PreviewProvider {
    static var previews: some View {
        GridItemLinkView(item: CoreDataManager.previewItem)
    }
}
