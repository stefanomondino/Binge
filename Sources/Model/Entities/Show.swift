//
//  Show.swift
//  Model
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation

public protocol ShowItem: ItemContainer {
    var year: Int? { get }
    var show: ShowItem { get }
}

public protocol ShowDetail: ItemDetail, ShowItem {
    var overview: String { get }
    var info: Show.Info? { get }
}

public enum Show {
    public struct Trending: WatchedItem, Codable, ShowItem {
        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case watchers
        }

        public static var demo: Trending {
            return Trending(showItem: ShowItemImplementation(title: "Test", ids: Ids(trakt: 0, slug: "this-is-test"), year: 2000), watchers: 2)
        }

        private let showItem: ShowItemImplementation
        private let watchers: Int
        public var watcherCount: Int { watchers }
        public var item: Item { showItem }
        public var show: ShowItem { showItem }
        public var year: Int? { show.year }
    }

    public struct Played: WatchedItem, PlayedItem, CollectedItem, ShowItem, Codable {
        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case watcherCount
            case playCount
            case collectedCount
            case collectorCount
        }

        public let watcherCount: Int
        public let playCount: Int
        public let collectedCount: Int
        public let collectorCount: Int?
        private let showItem: ShowItemImplementation
        public var item: Item { showItem }
        public var show: ShowItem { showItem }
        public var year: Int? { show.year }
    }

    public struct Anticipated: AnticipatedItem, Codable, ShowItem {
        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case listCount
        }

        private let showItem: ShowItemImplementation
        public let listCount: Int
        public var item: Item { showItem }
        public var show: ShowItem { showItem }
        public var year: Int? { show.year }
    }

    public struct Cast: CastItem, Codable, ShowItem {
        struct Response: Codable {
            let cast: [Cast]
        }

        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case episodeCount
            case characters
        }

        private let showItem: ShowItemImplementation
        public let characters: [String]
        public let episodeCount: Int?
        public var item: Item { showItem }
        public var show: ShowItem { showItem }
        public var year: Int? { show.year }
    }

    //    public struct Searched: SearchableItem, ShowItem {
    //        public let score: Double
    //        public let item: Item
    //
    //    }
    //
    internal struct ShowItemImplementation: ShowItem, Item {
        public let title: String
        let ids: Ids
        let year: Int?
        public var item: Item { self }
        public var show: ShowItem { self }
    }

    public struct Network: Codable {
        public let name: String?
        public let id: Int
        public let logoPath: String?
        public let originCountry: String?
    }

    public struct Genre: Codable {
        public let id: Int?
        public let name: String?
    }

    internal struct DetailItem: ShowDetail {
        var overview: String
        var title: String
        var year: Int?
        var ids: Ids
        var info: Info?
        var item: Item { self }
        var show: ShowItem { self }
        var aspectRatio: Double { 250 / 375.0 }

        var defaultImage: String? { backdropPath }

        var allowedSizes: KeyPath<TMDB.Image, [String]> { \.backdropSizes }
        var backdropPath: String?
    }

    public struct Info: Codable {
        public let name: String
        public let status: String?
        public let backdropPath: String?
        public let posterPath: String?
        public let seasons: [Season.Info]?
        public let episodeRuntime: [Int]?
        public let firstAirDate: String?
        public let lastAirDate: String?
        public let originCountry: [String]?
        public let originalLanguage: String?
        public let networks: [Network]?
        public let genres: [Genre]?
        public let popularity: Double?
    }
}
