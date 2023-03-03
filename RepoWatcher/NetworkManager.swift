//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/2/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    #error("Fix the Network Call")
    func getRepo(from urlString: String) async throws -> Repository {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidRepoURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try decoder.decode(Repository.self, from: data)
        } catch {
            throw NetworkError.invalidRepoData
        }
    }
}

enum NetworkError: Error {
    case invalidRepoURL
    case invalidResponse
    case invalidRepoData
}

enum RepoURL {
    static let swiftUIBuddy = "https://github.com/Daniel-Berezhnoy/SwiftUIBuddy"
    static let codeEdit = "https://github.com/CodeEditApp/CodeEdit"
    static let setting = "https://github.com/aheze/Setting"
    static let publish = "https://github.com/JohnSundell/Publish"
}
