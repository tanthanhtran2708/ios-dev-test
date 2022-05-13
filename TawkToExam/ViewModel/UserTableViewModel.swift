//
//  UserTableViewModel.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/19/21.
//

import UIKit

class UserTableViewModel {
    var didUpdateUserList: (()->())?
    var standardIdentifier = "standard"
    var invertedIdentifier = "inverted"
    var lastUserIDFetched = 0
    
    var allUsers: [UserRowData] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.didUpdateUserList?()
                if let lastUser = self?.visibleUsers.last {
                    self?.lastUserIDFetched = lastUser.id
                }
            }
        }
    }
    
    var userNotesDictionary: [String: String] = [:]
    
    var isFiltering = false {
        didSet {
            didUpdateUserList?()
        }
    }
    var filteredUsers: [UserRowData] = []
    
    var visibleUsers: [UserRowData] {
        return isFiltering ? filteredUsers: allUsers
    }
    
    func getUser(for index: Int) -> UserRowData {
        return visibleUsers[index]
    }
    
    private func fetchImageData(from urlString: String, completion: @escaping (Data?) ->()) {
        DispatchQueue.background(background: {
            SessionProvider().requestImageData(urlString: urlString) { result in
                switch result {
                case .failure(_):
                    completion(nil)
                case .success(let imageData):
                    completion(imageData)
                }
            }
        })
    }
    
    func filterUsers(searchText: String) {
        if !searchText.isEmpty {
            filteredUsers = allUsers.filter{ user in
                let textMatchesLoginName = user.login.lowercased().contains(searchText.lowercased())
                let adminText = "admin"
                let textSearchesAdmin = adminText.contains(searchText.lowercased()) && user.siteAdmin
                var textMatchesUserNote = false
                
                if let userNote = userNotesDictionary[user.login] {
                    textMatchesUserNote = userNote.lowercased().contains(searchText.lowercased())
                }
                
                return textMatchesLoginName || textSearchesAdmin || textMatchesUserNote
            }
            isFiltering = true
        } else {
            filteredUsers = []
            isFiltering = false
        }
    }
    
    func getIdentifier(for index: Int) -> String {
        if (index + 1) % 4 == 0 {
            return invertedIdentifier
        } else {
            return standardIdentifier
        }
    }
    
    func checkNoteExistence(forUserIn index: Int) -> Bool {
        let user = getUser(for: index)
        if let noteText = userNotesDictionary[user.login],
           !noteText.isEmpty {
            return true
        }
        return false
    }
}
