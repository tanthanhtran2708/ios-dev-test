//
//  BaseCoreDataManager.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import CoreData
import UIKit

class BaseCoreDataManager<T: CoreDataCoder> {
    let managedContext: NSManagedObjectContext
    let entityName: String
    lazy var coder = T()
    
    init(entityName: String, context: NSManagedObjectContext? = nil ) {
        if let context = context {
            managedContext = context
        } else  {
            managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        self.entityName = entityName
    }
    
    func retrieveAll(completion: (Result<[T.DataModel], CoreDataManagerError>)->()) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let rawData = try managedContext.fetch(fetchRequest)
            var outputData = [T.DataModel]()
            rawData.forEach { object in
                guard let decoded = try? coder.decode(object)
                else {
                    print("Error || could not decode object")
                    return
                }
                outputData.append(decoded)
            }
            completion(.success(outputData))
        } catch let error as NSError {
            print("Error || Could not fetch. \(error), \(error.userInfo)")
            completion(.failure(.parseFailure))
        }
    }
    
    func save(_ data: T.DataModel, completion: ((Bool)->())? = nil) {
        let newRowData = coder.encode(data)
        let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                in: managedContext)!
        let userRowDataEntity = NSManagedObject(entity: entity,
                                                insertInto: managedContext)
        
        for (key, value) in newRowData {
            userRowDataEntity.setValue(value, forKey: key)
        }
        
        do {
            try managedContext.save()
            completion?(true)
        } catch let error as NSError {
            print("Error || Could not save. \(error), \(error.userInfo)")
            completion?(false)
        }
    }
    
    func clearAll(completion: ((Bool)->())? = nil) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
//            try managedContext.save()
            completion?(true)
        } catch {
            print("Error || Could not clear User row data saved")
            completion?(false)
            // TODO: handle the error
        }
    }
}
