//
//  Movie.swift
//  Binge
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation

public protocol MovieItem: ItemContainer {}

public protocol MovieDetail: ItemDetail, MovieItem {
    var info: Movie.Info? { get }
}

public enum Movie {
    public struct Trending: WatchedItem, Codable, MovieItem {
        private enum CodingKeys: String, CodingKey {
            case movieItem = "movie"
            case watchers
        }

        public static var demo: Trending {
            return Trending(movieItem: MovieItemImplementation(title: "Test", ids: Ids(trakt: 0, slug: "this-is-test"), year: 2000), watchers: 2)
        }

        private let movieItem: MovieItemImplementation
        private let watchers: Int
        public var watcherCount: Int { watchers }
        public var item: Item { return movieItem }
    }

    public struct Played: WatchedItem, PlayedItem, CollectedItem, Codable, MovieItem {
        private enum CodingKeys: String, CodingKey {
            case movieItem = "movie"
            case watcherCount
            case playCount
            case collectedCount
            case collectorCount
        }

        public let watcherCount: Int
        public let playCount: Int
        public let collectedCount: Int
        public let collectorCount: Int?
        private let movieItem: MovieItemImplementation
        public var item: Item { return movieItem }
    }

    public struct Anticipated: AnticipatedItem, Codable, MovieItem {
        private enum CodingKeys: String, CodingKey {
            case movieItem = "movie"
            case listCount
        }

        private let movieItem: MovieItemImplementation
        public let listCount: Int
        public var item: Item { movieItem }
    }

    public struct Searched: SearchableItem, MovieItem {
        public let score: Double
        public let item: Item
    }

    internal struct MovieItemImplementation: MovieItem, Item {
        public let title: String
        let ids: Ids
        let year: Int?
        public var item: Item { return self }
    }

    internal struct DetailItem: MovieDetail {
        var overview: String
        var runtime: Int
        var title: String
        var year: Int?
        var ids: Ids
        var info: Info?
        var item: Item { return self }
    }

    public struct Info: Codable {
        public let name: String?
        public let backdropPath: String?
        public let posterPath: String?
//        public let seasons: [Season.Info]?
    }
}
