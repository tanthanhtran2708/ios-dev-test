//
//  UserNoteCoreDataCoder.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import CoreData

struct UserNoteCoreDataCoder: CoreDataCoder {
    typealias DataModel = UserNote
    
    func decode(_ object: NSManagedObject) throws -> UserNote {
        guard let username = object.value(forKeyPath: "username") as? String,
              let noteBody = object.value(forKeyPath: "noteBody") as? String
        else {
            throw CoreDataManagerError.parseFailure
        }
        return UserNote(username: username, noteBody: noteBody)
    }

    func encode(_ data: UserNote) -> [String : Any] {
        return [
            "username": data.username,
            "noteBody": data.noteBody
        ]
    }
}
