//
//  UserNoteCoreDataManager.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

import CoreData
import UIKit

class UserNoteCoreDataManager: BaseCoreDataManager<UserNoteCoreDataCoder> {
    init(context: NSManagedObjectContext? = nil) {
        super.init(entityName: "UserNoteCoreData", context: context)
    }

    var storage: [String: String] = [:]

    func getAllDataAndStore(completion: (([String: String])->())? = nil) {
        retrieveAll { result in
            switch result {
            case .failure(_):
                print("Error || Retrieving for UserNote failed")
            case .success(let array):
                array.forEach{ storage[$0.username] = $0.noteBody }
                completion?(storage)
            }
        }
    }
}
