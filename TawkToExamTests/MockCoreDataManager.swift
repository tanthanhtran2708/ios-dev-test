//
//  MockCoreDataManager.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import CoreData

class MockCoreDataManager: BaseCoreDataManager<MockCoder> {
    init() {
        super.init(entityName: "MockDataModelCoreData",
                   context: TestUtil.makeCoreDataContext())
    }
    
    override func clearAll(completion: ((Bool)->())? = nil) {
        guard let storeCoordinator = managedContext.persistentStoreCoordinator,
              let lastStore = storeCoordinator.persistentStores.last
        else {
            completion?(false)
            return
        }
        let storeURL = storeCoordinator.url(for: lastStore)
        do {
            try storeCoordinator.remove(lastStore)
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            completion?(false)
        }
    }
}

struct MockCoder: CoreDataCoder {
    func decode(_ object: NSManagedObject) throws -> MockDataModel {
        guard let id = object.value(forKey: "id") as? Int,
              let name = object.value(forKey: "name") as? String
        else {
            fatalError()
        }
        return MockDataModel(id: id, name: name)
    }

    func encode(_ data: MockDataModel) -> [String : Any] {
        return [
            "id": data.id,
            "name": data.name
        ]
    }
    
    typealias DataModel = MockDataModel
}
