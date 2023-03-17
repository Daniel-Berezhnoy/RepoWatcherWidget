//
//  RepoListView.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import SwiftUI
import SwiftUIBuddy

struct RepoListView: View {
    
    @State private var newRepo = ""
    @State private var repos: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                addRepoField
                savedRepos
            }
            .navigationTitle("Repo List")
        }
        .onAppear { retrieveSavedRepos() }
    }
    
    var addRepoField: some View {
        HStack {
            TextField("Ex. sallen0400/swift-news", text: $newRepo)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            Button {
                if !repos.contains(newRepo) {
                    appendRepos(with: newRepo)
                } else {
                    // TODO: Show Alert "ERROR: This repo is already saved."
                }
                
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.green)
            }
            .disabled(repoNameIsEmpty)
            .opacity(repoNameIsEmpty ? 0.6 : 1)
        }
        .padding()
    }
    
    var savedRepos: some View {
        VStack(alignment: .leading) {
            Text("Saved Repos")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)
            
            List(repos, id: \.self) { repo in
                Text(repo)
                    .swipeActions {
                        Button("Delete") {
                            
                        }
                        .tint(.red)
                    }
            }
        }
    }
    
    var repoNameIsEmpty: Bool {
        newRepo.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
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
}

struct RepoList_Previews: PreviewProvider {
    static var previews: some View {
        RepoListView()
    }
}
