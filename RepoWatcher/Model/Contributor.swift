//
//  Contributor.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/5/23.
//

import Foundation

struct Contributor {
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data
}

extension Contributor {
    struct CodingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int
        
        var contributor: Contributor {
            Contributor(login: login, avatarUrl: avatarUrl, contributions: contributions, avatarData: Data())
        }
    }
}
