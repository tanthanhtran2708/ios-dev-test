//
//  ProfileViewModel.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

class ProfileViewModel {
    let username: String
    let avatarUrl: String
    let isSiteAdmin: Bool
    
    init(user: UserRowData) {
        self.username = user.login
        self.avatarUrl = user.avatarUrl
        self.isSiteAdmin = user.siteAdmin
    }
}
