//
//  RepoListViewModel.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/17/23.
//

import SwiftUI

extension RepoListView {
    @MainActor class RepoListViewModel: ObservableObject {
        
        @Published var newRepo = ""
        @Published var repos: [String] = []
        
        @Published var alertMessage = ""
        @Published var showingAlert = false
        
        func appendRepos(with newRepo: String) {
            repos.append(newRepo)
            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
            self.newRepo.removeAll()
        }
        
        func retrieveSavedRepos() {
            guard let retrievedRepos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
                
                let defaultRepos = ["Daniel-Berezhnoy/SwiftUIBuddy"]
                UserDefaults.shared.set(defaultRepos, forKey: UserDefaults.repoKey)
                repos = defaultRepos
                
                return
            }
            
            repos = retrievedRepos
        }
        
        func presentAlert(_ message: String) {
            alertMessage = message
            showingAlert = true
            newRepo.removeAll()
        }
    }
}
