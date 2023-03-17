//
//  RepoListView.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import SwiftUI
import SwiftUIBuddy

struct RepoListView: View {
    @StateObject private var viewModel = RepoListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                addRepoField
                savedRepos
            }
            .navigationTitle("Repo List")
        }
        .onAppear { viewModel.retrieveSavedRepos() }
        
        .alert("Error", isPresented: $viewModel.showingAlert) {
            Button("Ok") {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    var addRepoField: some View {
        HStack {
            
            // Text Field
            TextField("Ex. sallen0400/swift-news", text: $viewModel.newRepo)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .onSubmit { addRepoWithKeyboard() }

            // Plus Button
            Button {
                addRepoWithButton()
                
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.green)
            }
            .disabled(viewModel.repoNameIsEmpty)
            .opacity(viewModel.repoNameIsEmpty ? 0.6 : 1)
        }
        .padding()
    }
    
    var savedRepos: some View {
        VStack(alignment: .leading) {
            
            // Text Label
            Text("Saved Repos")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)
            
            // List
            List(viewModel.repos, id: \.self) { repo in
                Text(repo)
                    .swipeActions {
                        Button("Delete") {
                            deleteRepo(repo)
                        }
                        .tint(.red)
                    }
            }
        }
    }
    
    func addRepoWithKeyboard() {
        if viewModel.repos.contains(viewModel.newRepo) {
            viewModel.presentAlert("\(viewModel.newRepo) was already saved.")
            
        } else if viewModel.repoNameIsEmpty{
            viewModel.presentAlert("Please enter the repo name and try again")
            
        } else {
            withAnimation { viewModel.appendRepos(with: viewModel.newRepo) }
        }
    }
    
    func addRepoWithButton() {
        if viewModel.repos.contains(viewModel.newRepo) {
            viewModel.presentAlert("\(viewModel.newRepo) was already saved.")
        } else {
            withAnimation { viewModel.appendRepos(with: viewModel.newRepo) }
        }
    }
    
    func deleteRepo(_ repo: String) {
        if viewModel.repos.count > 1 {
            withAnimation {
                viewModel.repos.removeAll { $0 == repo }
                UserDefaults.shared.set(viewModel.repos, forKey: UserDefaults.repoKey)
            }
        } else {
            viewModel.presentAlert("You need to have at least one repo.")
        }
    }
}

struct RepoList_Previews: PreviewProvider {
    static var previews: some View {
        RepoListView()
    }
}
