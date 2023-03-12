//
//  IntentHandler.swift
//  WidgetIntents
//
//  Created by Daniel Berezhnoy on 3/11/23.
//

import Intents
//import WidgetIntents
//import IntentsUI
//import AppIntents
//import WidgetKit
//import SwiftUI

class IntentHandler: INExtension, RepoIntentHandling {
    
    func provideSelectedRepoOptionsCollection(for intent: RepoIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<Repo>?, Error?) -> Void) {
        let repos: [Repo] = [
            Repo(identifier: "SwiftUIBuddy", display: "SwiftUIBuddy"),
            Repo(identifier: nil, display: "Setting")
        ]

        // Create a collection with the array of characters.
        let collection = INObjectCollection(items: repos)

        // Call the completion handler, passing the collection.
        completion(collection, nil)
    }
    
    // MARK: Async version of the function
//    func provideSelectedRepoOptionsCollection(for intent: RepoIntent, searchTerm: String?) async throws -> INObjectCollection<Repo> {
//        let repos: [Repo] = [
//            Repo(identifier: "SwiftUIBuddy", display: "SwiftUIBuddy"),
//            Repo(identifier: nil, display: "Setting")
//        ]
//
//        // Create a collection with the array of characters.
//        let collection = INObjectCollection(items: repos)
//
//        // Return the collection.
//        return collection
//    }
}
