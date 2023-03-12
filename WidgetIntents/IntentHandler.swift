//
//  IntentHandler.swift
//  WidgetIntents
//
//  Created by Daniel Berezhnoy on 3/11/23.
//

import Intents

class IntentHandler: INExtension {
    
    func provideRepoCollection(for intent: RepoIntent, with completion: @escaping (INObjectCollection<Repo>?, Error?) -> Void) {
        
        let repos: [Repo] = [
            Repo(identifier: "SwiftUIBuddy", display: "SwiftUIBuddy"),
            Repo(identifier: nil, display: "Setting")
        ]
        
        // Create a collection with the array of characters.
        let collection = INObjectCollection(items: repos)
        
        // Call the completion handler, passing the collection.
        completion(collection, nil)
    }
}
