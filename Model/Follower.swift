//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Lee Sangoroh on 04/03/2024.
//

import Foundation

// Strings conforms to Hashable so we just declare it on the struct
struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}
