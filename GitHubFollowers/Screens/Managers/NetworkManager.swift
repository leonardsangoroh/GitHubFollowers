//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Lee Sangoroh on 05/03/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
        
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidUsername)
            return
        }
        
        let token = "token"
        var request = URLRequest(url: url)
//        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.allHTTPHeaderFields = [
            "Accept" : "application/vnd.github+json",
            "Authorization" : "\(token)",
            "X-GitHub-Api-Version" : "2022-11-28"
            
        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completed(nil, .unableToComplete)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, .invalidData )
                //completed(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
}

