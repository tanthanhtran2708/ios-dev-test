//
//  CoreDataManagerTest.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/26/21.
//

import XCTest
@testable import TawkToExam
import CoreData

class CoreDataManagerTest: XCTestCase {
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        mockCoreDataManager = MockCoreDataManager()
    }
    
    override func tearDown() {
        mockCoreDataManager = nil
    }
    
    func testSaveData() {
        let sampleData = givenThatIHaveASampleData()
        whenISave(sampleData)
        thenInRetrievedData(iShouldSee: sampleData)
    }
    
    func testClearData() {
        givenThatIHaveMultipleDataSavedOnMemory()
        whenIClearMemory()
        thenMemoryShouldBeEmpty()
    }
    
    private func givenThatIHaveMultipleDataSavedOnMemory() {
        let sampleDataArray: [MockDataModel] = [
            .generateRandomData(),
            .generateRandomData(),
            .generateRandomData(),
        ]
        
        sampleDataArray.forEach { model in
            mockCoreDataManager.save(model) { didSucceed in
                if !didSucceed { XCTFail("Failed to save data") }
            }
        }
    }
    
    private func whenIClearMemory() {
        mockCoreDataManager.clearAll { didSucceed in
            if !didSucceed { XCTFail("Failed to clear data") }
        }
    }
    
    private func thenMemoryShouldBeEmpty() {
        mockCoreDataManager.retrieveAll { result in
            switch result {
            case .failure(_):
                XCTFail("Failed to retrieve")
            case .success(let array):
                XCTAssert(array.isEmpty)
            }
        }
    }
    
    private func givenThatIHaveASampleData() -> MockDataModel {
        return MockDataModel.generateRandomData()
    }
    
    private func whenISave(_ mockDataModel: MockDataModel) {
        mockCoreDataManager.save(mockDataModel) { didSucceed in
            XCTAssertTrue(didSucceed, "Failed to save data")
        }
    }
    
    private func thenInRetrievedData(iShouldSee sampleData: MockDataModel) {
        sleep(2)
        mockCoreDataManager.retrieveAll { result in
            switch result {
            case .failure(_):
                XCTFail("Data retrieval failed")
            case .success(let allData):
                XCTAssert(!allData.isEmpty, "Data returned is empty")
                XCTAssertEqual(allData.first?.id, sampleData.id, "Unexpected `id` found")
                XCTAssertEqual(allData.first?.name, sampleData.name, "Unexpected `name` found")
            }
        }
        
    }
}
