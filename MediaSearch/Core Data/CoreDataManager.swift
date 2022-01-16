//
//  CoreDataManager.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    static let preview: CoreDataManager = {
        let manager = CoreDataManager(inMemory: true)
        let viewContext = manager.container.viewContext
        
        for number in 1...21 {
            let favorite = FavoriteMedia(context: viewContext)
            favorite.id = "\(number)"
            favorite.title = "Title \(number)"
            favorite.image = nil

            if number <= 7 {
                favorite.mediaType = .ebook
            } else if number <= 14 {
                favorite.mediaType = .movie
            } else {
                favorite.mediaType = .tvShow
            }
        }

        try? viewContext.save()

        return manager
    }()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MediaSearch")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { [weak self] storeDescription, error in
            guard error == nil else { return }
            print("storeDesc", storeDescription)

            self?.container.viewContext.automaticallyMergesChangesFromParent = true
            self?.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }

}
