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
    let ids: Ids

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

    public struct Account: Codable {
        let coverImage: String?
    }

    struct Ids: Codable {
        let slug: String
        let uuid: String
    }

    public struct Settings: Codable {
        public struct Connections: Codable {
            let facebook: Bool
        }

        public let account: Account?
        public let user: User

        public var coverURL: URL? {
            guard let path = account?.coverImage,
                let url = URL(string: path) else { return nil }
            return url
        }
    }
}

public struct UserWatched: Codable, ItemContainer {
    private struct Empty: Item {
        var title: String = ""
        var ids: Ids = Ids(trakt: 0, slug: "")
        var item: Item { self }
    }

    public var item: Item { (show ?? movie) ?? UserWatched.Empty() }

    public var watchedAt: String
    var show: Show.ShowItemImplementation?
    var movie: Movie.MovieItemImplementation?
//    var episode: Season.Episode?
    var season: Season.Info?
}
