//
//  UserRowCoder.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import XCTest
import CoreData

class UserRowCoderTest: XCTestCase {
    var coder: UserRowCoreDataCoder!
    var row: UserRowData!
    var encodedRow: [String: Any]!
    var decodedRow: UserRowData!
    
    var reencoded: [String: Any]!
    
    override func setUp() {
        coder = UserRowCoreDataCoder()
        row = UserRowData(id: Int.random(in: 0...10),
                          avatarUrl: TestUtil.randomString(length: 10),
                          login: TestUtil.randomString(length: 10),
                          siteAdmin: Bool.random(),
                          type: TestUtil.randomString(length: 10))
        
    }
    
    override func tearDown() {
        coder = nil
        row = nil
        encodedRow = nil
        decodedRow = nil
    }
    
    func testDecodeThenEncode() {
        givenThatUserRowIsProvided()
        whenIDecodeTheManagedObject()
        thenEncodeItAgain()
        thenInputAndOutputDataShouldMatch()
    }
    func testEncode() {
        givenThatUserRowIsProvided()
        whenIEncodeTheRow()
        thenIShouldHaveRightKeysAssignedToTheDictionary()
    }
    
    func testDecode() {
        givenThatUserRowIsProvided()
        whenIDecodeTheManagedObject()
        thenRowProdedShouldMatchTheDecoded()
    }
    
    private func givenThatUserRowIsProvided() {
        XCTAssertNotNil(row)
    }
    
    private func whenIEncodeTheRow() {
        let encoded = coder.encode(row)
        XCTAssertFalse(encoded.keys.isEmpty, "Keys are empty")
        encodedRow = encoded
    }
    
    private func thenEncodeItAgain() {
        reencoded = coder.encode(decodedRow)
    }
    
    private func thenInputAndOutputDataShouldMatch() {
        XCTAssertEqual(reencoded["id"] as? Int, row.id, "Unexpected value found")
        XCTAssertEqual(reencoded["avatarUrl"] as? String, row.avatarUrl, "Unexpected value found")
        XCTAssertEqual(reencoded["login"] as? String, row.login, "Unexpected value found")
        XCTAssertEqual(reencoded["siteAdmin"] as? Bool, row.siteAdmin, "Unexpected value found")
        XCTAssertEqual(reencoded["type"] as? String, row.type, "Unexpected value found")
    }
    
    
    private func thenIShouldHaveRightKeysAssignedToTheDictionary() {
        guard let row = row
        else {
            XCTFail("no Row assignedf")
            return
        }
        let mirror = Mirror(reflecting: row.self).children.compactMap { $0.label }
        XCTAssertEqual(encodedRow.keys.count, mirror.count, "unexpected keys detected")
        
        encodedRow.forEach { keyValue in
            XCTAssert(mirror.contains(keyValue.key))
        }
    }
    
    private func whenIDecodeTheManagedObject() {
        decodedRow = try? coder.decode(MockRowManagedObject(id: row.id, avatarUrl: row.avatarUrl, login: row.login, siteAdmin: row.siteAdmin, type: row.type))
        XCTAssertNotNil(decodedRow)
    }
    
    private func thenRowProdedShouldMatchTheDecoded() {
        XCTAssertEqual(decodedRow.id, row.id, "Unexpected value found")
        XCTAssertEqual(decodedRow.avatarUrl, row.avatarUrl, "Unexpected value found")
        XCTAssertEqual(decodedRow.login, row.login, "Unexpected value found")
        XCTAssertEqual(decodedRow.siteAdmin, row.siteAdmin, "Unexpected value found")
        XCTAssertEqual(decodedRow.type, row.type, "Unexpected value found")
    }
}

class RowManagedObject: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var avatarUrl: String
    @NSManaged public var login: String
    @NSManaged public var siteAdmin: Bool
    @NSManaged public var type: String
}

class MockRowManagedObject: RowManagedObject {
    
    convenience init(id: Int, avatarUrl: String, login: String, siteAdmin: Bool, type: String) {
        self.init()
        
        self.mockID = id
        self.mockAvatarUrl = avatarUrl
        self.mockLogin = login
        self.mockSiteAdmin = siteAdmin
        self.mockType = type
    }
    
    var mockID: Int = 0
    override var id: Int {
        set {}
        get {
            return mockID
        }
    }
    
    var mockAvatarUrl: String = ""
    override var avatarUrl: String {
        set {}
        get {
            return mockAvatarUrl
        }
    }
    
    var mockLogin: String = ""
    override var login: String {
        set {}
        get {
            return mockLogin
        }
    }
    
    var mockSiteAdmin: Bool = false
    override var siteAdmin: Bool {
        set {}
        get {
            return mockSiteAdmin
        }
    }
    
    var mockType: String = ""
    override var type: String {
        set {}
        get {
            return mockType
        }
    }
}
