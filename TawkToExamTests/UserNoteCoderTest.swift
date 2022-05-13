//
//  UserNoteCoderTest.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import XCTest
import CoreData

class UserNoteCoderTest: XCTestCase {
    var coder: UserNoteCoreDataCoder!
    var note: UserNote!
    var encodedNote: [String: Any]!
    var decodedNote: UserNote!
    
    var reencoded: [String: Any]!
    
    override func setUp() {
        coder = UserNoteCoreDataCoder()
        note = UserNote(username: TestUtil.randomString(length: 10),
                            noteBody: TestUtil.randomString(length: Int.random(in: 20...40)))
    }
    
    override func tearDown() {
        coder = nil
        note = nil
        encodedNote = nil
        decodedNote = nil
    }
    
    func testDecodeThenEncode() {
        givenThatUserNoteIsProvided()
        whenIDecodeTheManagedObject()
        thenEncodeItAgain()
        thenInputAndOutputDataShouldMatch()
    }
    func testEncode() {
        givenThatUserNoteIsProvided()
        whenIEncodeTheNote()
        thenIShouldHaveRightKeysAssignedToTheDictionary()
    }
    
    func testDecode() {
        givenThatUserNoteIsProvided()
        whenIDecodeTheManagedObject()
    }
    
    private func givenThatUserNoteIsProvided() {
        XCTAssertNotNil(note)
    }
    
    private func whenIEncodeTheNote() {
        let encoded = coder.encode(note)
        XCTAssertFalse(encoded.keys.isEmpty, "Keys are empty")
        encodedNote = encoded
    }
    
    private func thenEncodeItAgain() {
        reencoded = coder.encode(decodedNote)
    }
    
    private func thenInputAndOutputDataShouldMatch() {
        XCTAssertEqual(reencoded["username"] as? String, decodedNote.username, "Unexpected value found")
        XCTAssertEqual(reencoded["noteBody"] as? String, decodedNote.noteBody, "Unexpected value found")
    }
    
    
    private func thenIShouldHaveRightKeysAssignedToTheDictionary() {
        guard let note = note
        else {
            XCTFail("no note")
            return
        }
        let mirror = Mirror(reflecting: note.self).children.compactMap { $0.label }
        XCTAssertEqual(encodedNote.keys.count, mirror.count, "unexpected keys detected")
        
        encodedNote.forEach { keyValue in
            XCTAssert(mirror.contains(keyValue.key))
        }
    }
    
    private func whenIDecodeTheManagedObject() {
        decodedNote = try? coder.decode(MockNoteManagedObject(username: note.username, noteBody: note.noteBody))
        XCTAssertNotNil(decodedNote)
    }
    
    private func thenNoteProdedShouldMatchTheDecoded() {
        XCTAssertEqual(decodedNote.username, note.username)
        XCTAssertEqual(decodedNote.noteBody, note.noteBody)
    }
}

class NoteManagedObject: NSManagedObject {
    @NSManaged public var username: String
    @NSManaged public var noteBody: String
}

class MockNoteManagedObject: NoteManagedObject {
    convenience init(username: String, noteBody: String) {
        self.init()
        self.mockUserName = username
        self.mockNoteBody = noteBody
    }
    
    var mockUserName: String = ""
    override var username: String {
        set {}
        get {
            return mockUserName
        }
    }
    
    var mockNoteBody: String = ""
    override var noteBody: String {
        set {}
        get {
            return mockNoteBody
        }
    }
}
