//
//  FavoritesSummaryRowView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import SwiftUI

struct FavoritesSummaryGridItemView: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44)
            Text(text)
                .bold()
                .lineLimit(2)
                .padding([.leading], 5)
            Spacer()

        }
        .frame(width: 250, height: 54)
        .padding([.leading, .trailing], 12)
    }
}

struct FavoritesSummaryGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesSummaryGridItemView(text: "Long Title 1 Random Headline Sub headline third")
    }
}
