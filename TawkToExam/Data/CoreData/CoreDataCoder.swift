//
//  CoreDataCoder.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import CoreData

protocol CoreDataCoder {
    associatedtype DataModel
    
    init()
    func decode(_ object: NSManagedObject) throws -> DataModel
    func encode(_ data: DataModel) -> [String : Any]
}
