//
//  UserProfileInfoCoreDataManager.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

import CoreData
import UIKit

class UserProfileInfoCoreDataManager: BaseCoreDataManager<ProfileInfoCoreDataCoder> {
    init(context: NSManagedObjectContext? = nil) {
        super.init(entityName: "UserProfileInfoCoreData", context: context)
    }
    
    var storage: [String: UserProfileInfo] = [:]
}
