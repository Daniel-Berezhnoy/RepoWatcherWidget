//
//  ContentView.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import SwiftUI
import SwiftUIBuddy

struct ContentView: View {
    @EnvironmentObject private var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Text("Selected Repo:")
                .font(.title)
                .fontWeight(.bold)
            
            LoginField("Repo", text: $viewModel.selectedRepo)
                .padding()
            
//                .onChange(of: viewModel.selectedRepo) { newValue in
//                    print("Selected Repo: \(newValue)")
//                }
            
                .onSubmit {
                    print("Selected Repo: \(viewModel.selectedRepo)")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentViewModel())
    }
}
