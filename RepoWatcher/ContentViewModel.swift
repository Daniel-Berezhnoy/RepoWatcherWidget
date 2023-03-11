//
//  ContentViewModel.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/11/23.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var selectedRepo = "https://api.github.com/repos/Daniel-Berezhnoy/SwiftUIBuddy"
}
