//
//  ProfileInfoCoreDataCoder.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/28/21.
//

import CoreData

struct ProfileInfoCoreDataCoder: CoreDataCoder {
    typealias DataModel = UserProfileInfo
    init() { }
    
    func decode(_ object: NSManagedObject) throws -> UserProfileInfo {
        guard let id = object.value(forKeyPath: "id") as? Int,
            let login = object.value(forKeyPath: "login") as? String,
            let avatarUrl = object.value(forKeyPath: "avatarUrl") as? String,
            let followers = object.value(forKeyPath: "followers") as? Int,
            let following = object.value(forKeyPath: "following") as? Int,
            let name = object.value(forKeyPath: "name") as? String?,
            let company = object.value(forKeyPath: "company") as? String?,
            let blog = object.value(forKeyPath: "blog") as? String
        else {
            throw CoreDataManagerError.parseFailure
        }

        return UserProfileInfo(id: id, login: login, avatarUrl: avatarUrl, followers: followers, following: following, name: name, company: company, blog: blog)
    }

    func encode(_ data: UserProfileInfo) -> [String : Any] {
        return [
            "id": data.id,
            "login": data.login,
            "avatarUrl": data.avatarUrl,
            "followers": data.followers,
            "following": data.following,
            "name": data.name ?? "",
            "company": data.company ?? "",
            "blog": data.blog,
        ]
    }
}
