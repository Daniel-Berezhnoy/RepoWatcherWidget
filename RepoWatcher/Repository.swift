//
//  Repository.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/2/23.
//

import Foundation

struct Repository {
    let name: String
    let description: String
    let owner: Owner
    let hasIssues: Bool
    
    let forks: Int
    let watchers: Int
    let openIssues: Int
    
    let pushedAt: String
    var avatarData: Data
}

struct Owner: Decodable {
    let avatarUrl: String
}

extension Repository {
    static let placeholder = Repository(name: "Your Repository",
                                        description: "A Library of Custom SwiftUI Components",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: true,
                                        forks: 55,
                                        watchers: 123,
                                        openIssues: 27,
                                        pushedAt: "2023-02-24T19:20:53Z",
                                        avatarData: Data())
}

extension Repository {
    struct CodingData: Decodable {
        
        let name: String
        let description: String
        let owner: Owner
        let hasIssues: Bool
        
        let forks: Int
        let watchers: Int
        let openIssues: Int
        
        let pushedAt: String
        
        
        var repo: Repository {
            Repository(name: name,
                       description: description,
                       owner: owner,
                       hasIssues: hasIssues,
                       forks: forks,
                       watchers: watchers,
                       openIssues: openIssues,
                       pushedAt: pushedAt,
                       avatarData: Data())
        }
    }
}
