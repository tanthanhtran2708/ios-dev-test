//
//  TestUtil.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/26/21.
//

import Foundation
import CoreData

struct TestUtil {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func makeCoreDataContext() -> NSManagedObjectContext {
        guard let url = Bundle.main.url(forResource: "MockDataModelCoreData", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url)
        else {
            fatalError("Failed to load MockDataModelCoreData")
        }
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(
            name: String(describing: MockDataModel.self),
          managedObjectModel: model)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        return container.viewContext
    }
}
