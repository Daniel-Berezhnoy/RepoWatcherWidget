//
//  IntentHandler.swift
//  RepoWatcherIntents
//
//  Created by Daniel Berezhnoy on 3/18/23.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation. If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
}

extension IntentHandler: SelectRepoIntentHandling {
    func provideRepoOptionsCollection(for intent: SelectRepoIntent) async throws -> INObjectCollection<NSString> {
        
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrieval
        }
        return INObjectCollection(items: repos as [NSString])
    }
    
    func defaultRepo(for intent: SelectRepoIntent) -> String? {
        "Daniel-Berezhnoy/SwiftUIBuddy"
    }
}
