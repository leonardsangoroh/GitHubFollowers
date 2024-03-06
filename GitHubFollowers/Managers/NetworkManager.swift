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
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        
        let endpoint = baseURL + "\(username)/follwers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username created an invalid request. Please try again")
            return
        }
        
        let token = "token"
        var request = URLRequest(url: url)
//        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.allHTTPHeaderFields = [
            "Accept" : "application/vnd.github+json",
            //"Authorization" : "\(token)",
            "X-GitHub-Api-Version" : "2022-11-28"
            
        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completed(nil, "Unable to complete your request. Please check your internet connection")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server. Please try again.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server was invalid. Please try again")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "The data received from the server was invalid. Please try again")
            }
        }
        task.resume()
    }
}

