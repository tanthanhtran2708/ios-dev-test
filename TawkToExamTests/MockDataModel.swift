//
//  MockDataModel.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

struct MockDataModel {
    let id: Int
    let name: String
}

extension MockDataModel {
    static func generateRandomData() -> MockDataModel {
        let id = Int.random(in: 0...99)
        let name = TestUtil.randomString(length: 10)
        return MockDataModel(id: id, name: name)
    }
}
