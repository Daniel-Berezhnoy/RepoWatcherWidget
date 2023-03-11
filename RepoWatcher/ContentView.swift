//
//  ContentView.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import SwiftUI
import SwiftUIBuddy

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Selected Repo:")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(NetworkManager.shared.selectedRepoURL)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
