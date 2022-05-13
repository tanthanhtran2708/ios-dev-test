//
//  UserRowCoreDataManager.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//
import UIKit
import CoreData

class UserRowCoreDataManager: BaseCoreDataManager<UserRowCoreDataCoder> {
    init(context: NSManagedObjectContext? = nil) {
        super.init(entityName: "UserRowCoreData", context: context)
    }
}
