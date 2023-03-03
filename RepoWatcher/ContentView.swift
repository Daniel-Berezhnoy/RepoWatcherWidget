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
        
        let swiftUIBuddyURL = "https://github.com/Daniel-Berezhnoy/SwiftUIBuddy"
        let publishURL = "https://github.com/JohnSundell/Publish"
        
        VStack {
            StandardButton("Fire off the Network Call 🚀") {
                do {
                    Task {
                        try await NetworkManager.shared.getRepo(from: publishURL)
                    }
                } catch {
                    print("❌ ERROR: \(error.localizedDescription)")
                }
            }
        }
        .padding(.horizontal, 25)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
