//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/17/23.
//

import Foundation

extension UserDefaults {
    static let repoKey = "repos"
    
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.com.daniel.RepoWatcher")!
    }
}
