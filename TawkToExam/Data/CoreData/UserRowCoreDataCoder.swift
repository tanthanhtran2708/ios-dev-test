//
//  UserRowCoreDataCoder.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import CoreData

struct UserRowCoreDataCoder: CoreDataCoder {
    init () { }
    
    func decode(_ object: NSManagedObject) throws -> UserRowData {
        guard let id = object.value(forKeyPath: "id") as? Int,
              let avatarUrl = object.value(forKeyPath: "avatarUrl") as? String,
              let login = object.value(forKeyPath: "login") as? String,
              let siteAdmin = object.value(forKeyPath: "siteAdmin") as? Bool,
              let type = object.value(forKeyPath: "type") as? String
        else {
            throw CoreDataManagerError.parseFailure
        }
        
        return UserRowData(id: id, avatarUrl: avatarUrl, login: login, siteAdmin: siteAdmin, type: type)
    }
    
    func encode(_ data: UserRowData) -> [String : Any] {
        return  [
            "id" : data.id,
            "avatarUrl" : data.avatarUrl,
            "login" : data.login,
            "siteAdmin" : data.siteAdmin,
            "type" : data.type,
        ]
    }
    
    typealias DataModel = UserRowData
}
