//
//  UserProfileCoderTest.swift
//  TawkToExamTests
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import XCTest
import CoreData

class UserProfileCoderTest: XCTestCase {
    var coder: ProfileInfoCoreDataCoder!
    var profileInfo: UserProfileInfo!
    var encodedProfileInfo: [String: Any]!
    var decodedProfileInfo: UserProfileInfo!
    var reencoded: [String: Any]!
    
    override func setUp() {
        coder = ProfileInfoCoreDataCoder()
        profileInfo = UserProfileInfo(id: Int.random(in: 0...10),
                                      login: TestUtil.randomString(length: 10),
                                      avatarUrl: TestUtil.randomString(length: 10),
                                      followers: Int.random(in: 0...10),
                                      following: Int.random(in: 0...10),
                                      name: TestUtil.randomString(length: 10),
                                      company: TestUtil.randomString(length: 10),
                                      blog: TestUtil.randomString(length: 10))
    }
    
    override func tearDown() {
        coder = nil
        profileInfo = nil
        encodedProfileInfo = nil
        decodedProfileInfo = nil
        reencoded = nil
    }
    
    func testDecodeThenEncode() {
        givenThatUserProfileInfoIsProvided()
        whenIDecodeTheManagedObject()
        thenEncodeItAgain()
        thenInputAndOutputDataShouldMatch()
    }
    func testEncode() {
        givenThatUserProfileInfoIsProvided()
        whenIEncodeTheProfileInfo()
        thenIShouldHaveRightKeysAssignedToTheDictionary()
    }
    
    func testDecode() {
        givenThatUserProfileInfoIsProvided()
        whenIDecodeTheManagedObject()
        thenProfileInfoProdedShouldMatchTheDecoded()
    }
    
    private func givenThatUserProfileInfoIsProvided() {
        XCTAssertNotNil(profileInfo)
    }
    
    private func whenIEncodeTheProfileInfo() {
        let encoded = coder.encode(profileInfo)
        XCTAssertFalse(encoded.keys.isEmpty, "Keys are empty")
        encodedProfileInfo = encoded
    }
    
    private func thenEncodeItAgain() {
        reencoded = coder.encode(decodedProfileInfo)
    }
    
    private func thenInputAndOutputDataShouldMatch() {
        XCTAssertEqual(reencoded["id"] as? Int, decodedProfileInfo.id, "Unexpected value found")
        XCTAssertEqual(reencoded["login"] as? String, decodedProfileInfo.login, "Unexpected value found")
        XCTAssertEqual(reencoded["avatarUrl"] as? String, decodedProfileInfo.avatarUrl, "Unexpected value found")
        XCTAssertEqual(reencoded["followers"] as? Int, decodedProfileInfo.followers, "Unexpected value found")
        XCTAssertEqual(reencoded["following"] as? Int, decodedProfileInfo.following, "Unexpected value found")
        XCTAssertEqual(reencoded["name"] as? String, decodedProfileInfo.name, "Unexpected value found")
        XCTAssertEqual(reencoded["company"] as? String, decodedProfileInfo.company, "Unexpected value found")
        XCTAssertEqual(reencoded["blog"] as? String, decodedProfileInfo.blog, "Unexpected value found")
    }
    
    
    private func thenIShouldHaveRightKeysAssignedToTheDictionary() {
        guard let profileInfo = profileInfo
        else {
            XCTFail("no note")
            return
        }
        let mirror = Mirror(reflecting: profileInfo.self).children.compactMap { $0.label }
        XCTAssertEqual(encodedProfileInfo.keys.count, mirror.count, "unexpected keys detected")
        
        encodedProfileInfo.forEach { keyValue in
            XCTAssert(mirror.contains(keyValue.key))
        }
    }
    
    private func whenIDecodeTheManagedObject() {
        decodedProfileInfo = try? coder.decode(MockProfileManagedObject(
                                                id: profileInfo.id,
                                                login: profileInfo.login,
                                                avatarUrl: profileInfo.avatarUrl,
                                                followers: profileInfo.followers,
                                                following: profileInfo.following,
                                                name: profileInfo.name!,
                                                company: profileInfo.company!,
                                                blog: profileInfo.blog))
        XCTAssertNotNil(decodedProfileInfo)
    }
    
    private func thenProfileInfoProdedShouldMatchTheDecoded() {
        XCTAssertEqual(decodedProfileInfo.id, profileInfo.id, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.login, profileInfo.login, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.avatarUrl, profileInfo.avatarUrl, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.followers, profileInfo.followers, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.following, profileInfo.following, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.name, profileInfo.name, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.company, profileInfo.company, "Unexpected value found")
        XCTAssertEqual(decodedProfileInfo.blog, profileInfo.blog, "Unexpected value found")
    }
}

class ProfileManagedObject: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var login: String
    @NSManaged public var avatarUrl: String
    @NSManaged public var followers: Int
    @NSManaged public var following: Int
    @NSManaged public var name: String
    @NSManaged public var company: String
    @NSManaged public var blog: String
}

class MockProfileManagedObject: ProfileManagedObject {
    convenience init(id: Int,
                     login: String,
                     avatarUrl: String,
                     followers: Int,
                     following: Int,
                     name: String,
                     company: String,
                     blog: String) {
        self.init()
        self.mockID = id
        self.mockLogin = login
        self.mockAvatarUrl = avatarUrl
        self.mockFollowers = followers
        self.mockFollowing = following
        self.mockName = name
        self.mockCompany = company
        self.mockBlog = blog
    }
    
    var mockID: Int = 0
    override var id: Int {
        set {}
        get {
            return mockID
        }
    }
    
    var mockLogin: String = ""
    override var login: String {
        set {}
        get {
            return mockLogin
        }
    }
    
    var mockAvatarUrl: String = ""
    override var avatarUrl: String {
        set {}
        get {
            return mockAvatarUrl
        }
    }
    
    var mockFollowers: Int = 0
    override var followers: Int {
        set {}
        get {
            return mockFollowers
        }
    }
    
    var mockFollowing: Int = 0
    override var following: Int {
        set {}
        get {
            return mockFollowing
        }
    }
    
    var mockName: String = ""
    override var name: String {
        set {}
        get {
            return mockName
        }
    }
    
    var mockCompany: String = ""
    override var company: String {
        set {}
        get {
            return mockCompany
        }
    }
    
    var mockBlog: String = ""
    override var blog: String {
        set {}
        get {
            return mockBlog
        }
    }
}
