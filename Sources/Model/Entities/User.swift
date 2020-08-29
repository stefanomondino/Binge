//
//  User.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Foundation

public struct User: Codable {
    public let username: String
    public let name: String
    public let vip: Bool
    public let location: String
    public let age: Int
    let images: Images?

    public var profileURL: URL? {
        guard let path = images?.avatar?.full,
            let url = URL(string: path) else { return nil }
        return url
    }

    public struct Images: Codable {
        public struct Image: Codable {
            let full: String?
        }

        var avatar: Image?
    }

    public struct Settings: Codable {
        public struct Connections: Codable {
            let facebook: Bool
        }

        let user: User
    }
}
