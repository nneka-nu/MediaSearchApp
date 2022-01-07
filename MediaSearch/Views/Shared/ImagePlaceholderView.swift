//
//  ImagePlaceholderView.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/6/22.
//

import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        Rectangle()
            .fill(Color("GrayColor"))
            .frame(width: 90, height: 100)
    }
}

struct ImagePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePlaceholderView()
    }
}
