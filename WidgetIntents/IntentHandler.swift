//
//  IntentHandler.swift
//  WidgetIntents
//
//  Created by Daniel Berezhnoy on 3/11/23.
//

import Intents

class IntentHandler: INExtension {
    
    //    override func handler(for intent: INIntent) -> Any {
    //        // This is the default implementation.  If you want different objects to handle different intents,
    //        // you can override this and return the handler you want for that particular intent.
    //
    //        return self
    //    }
    
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
