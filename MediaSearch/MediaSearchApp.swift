//
//  MediaSearchApp.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/3/22.
//

import SwiftUI

@main
struct MediaSearchApp: App {
    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
