//
//  UserService.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//

import Foundation

enum UserService: ServiceProtocol {
    var baseURL: String {
        return "https://api.github.com/"
    }
    
    var path: String {
        switch self {
        case let .getAll(lastUserIDFetched):
            return "users?since=\(lastUserIDFetched)"
        case let .getUser(username):
            return "users/\(username)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    /// Expects: last user ID fetched
    case getAll(Int)
    /// Expects: user's username
    case getUser(String)
}
