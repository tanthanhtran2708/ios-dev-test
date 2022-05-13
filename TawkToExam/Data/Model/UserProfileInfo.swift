//
//  UserProfileInfo.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//

struct UserProfileInfo: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let followers: Int
    let following: Int
    let name: String?
    let company: String?
    let blog: String
}

//{
//  "login": "tawk",
//  "id": 9743939,
//  "node_id": "MDEyOk9yZ2FuaXphdGlvbjk3NDM5Mzk=",
//  "avatar_url": "https://avatars.githubusercontent.com/u/9743939?v=4",
//  "gravatar_id": "",
//  "url": "https://api.github.com/users/tawk",
//  "html_url": "https://github.com/tawk",
//  "followers_url": "https://api.github.com/users/tawk/followers",
//  "following_url": "https://api.github.com/users/tawk/following{/other_user}",
//  "gists_url": "https://api.github.com/users/tawk/gists{/gist_id}",
//  "starred_url": "https://api.github.com/users/tawk/starred{/owner}{/repo}",
//  "subscriptions_url": "https://api.github.com/users/tawk/subscriptions",
//  "organizations_url": "https://api.github.com/users/tawk/orgs",
//  "repos_url": "https://api.github.com/users/tawk/repos",
//  "events_url": "https://api.github.com/users/tawk/events{/privacy}",
//  "received_events_url": "https://api.github.com/users/tawk/received_events",
//  "type": "Organization",
//  "site_admin": false,
//  "name": null,
//  "company": null,
//  "blog": "",
//  "location": null,
//  "email": null,
//  "hireable": null,
//  "bio": null,
//  "twitter_username": null,
//  "public_repos": 28,
//  "public_gists": 0,
//  "followers": 0,
//  "following": 0,
//  "created_at": "2014-11-14T12:23:56Z",
//  "updated_at": "2016-06-02T16:06:17Z"
//}
