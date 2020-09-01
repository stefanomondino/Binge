//
//  Show.swift
//  Model
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation

public protocol TraktShowItem: TraktItemContainer {
    var year: Int? { get }
    var show: TraktShowItem { get }
}

//
// public protocol ShowDetail: ItemDetail, ShowItem {
//    var overview: String { get }
//    var info: Show.Info? { get }
// }
public extension Trakt {
    enum Show {}
}

public extension TMDB {
    enum Show {}
}

public extension Trakt.Show {
    struct Item: TraktShowItem, TraktItem {
        public let title: String
        public let ids: Trakt.Ids
        public let year: Int?
        public var item: TraktItem { self }
        public var show: TraktShowItem { self }
    }

    struct Trending: TraktWatchedItem, Codable, TraktShowItem {
        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case watchers
        }

        public static var demo: Trending {
            return Trending(showItem: Item(title: "Test", ids: Trakt.Ids(trakt: 0, slug: "this-is-test"), year: 2000), watchers: 2)
        }

        private let showItem: Item
        private let watchers: Int
        public var watcherCount: Int { watchers }
        public var item: TraktItem { showItem }
        public var show: TraktShowItem { showItem }
        public var year: Int? { show.year }
    }

    struct Played: TraktWatchedItem, TraktPlayedItem, TraktCollectedItem, TraktShowItem, Codable {
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
        private let showItem: Item
        public var item: TraktItem { showItem }
        public var show: TraktShowItem { showItem }
        public var year: Int? { show.year }
    }

    struct Anticipated: TraktAnticipatedItem, Codable, TraktShowItem {
        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case listCount
        }

        private let showItem: Item
        public let listCount: Int
        public var item: TraktItem { showItem }
        public var show: TraktShowItem { showItem }
        public var year: Int? { show.year }
    }

    struct Cast: TraktCastItem, Codable, TraktShowItem {
        struct Response: Codable {
            let cast: [Cast]
        }

        private enum CodingKeys: String, CodingKey {
            case showItem = "show"
            case episodeCount
            case characters
        }

        private let showItem: Item
        public let characters: [String]
        public let episodeCount: Int?
        public var item: TraktItem { showItem }
        public var show: TraktShowItem { showItem }
        public var year: Int? { show.year }
    }

    struct Detail: Codable, TraktShowItem, TraktItemDetail {
        public var overview: String
        public var title: String
        public var year: Int?
        public var ids: Trakt.Ids
        public var info: TMDB.Show.Info?
        public var item: TraktItem { self }
        public var show: TraktShowItem { self }
    }
}

public extension TMDB.Show {
    struct Network: Codable {
        public let name: String?
        public let id: Int
        public let logoPath: String?
        public let originCountry: String?
    }

    struct Genre: Codable {
        public let id: Int?
        public let name: String?
    }

    struct Info: Codable, DownloadableImage {
        public var aspectRatio: Double { 1920 / 1080 }
        let id: Int
        public var uniqueIdentifier: String { "\(id)" }
        public let name: String
        public let status: String?
        public let backdropPath: String?
        public let posterPath: String?
        public let seasons: [TMDB.Season.Info]?
        public let episodeRuntime: [Int]?
        public let firstAirDate: String?
        public let lastAirDate: String?
        public let originCountry: [String]?
        public let originalLanguage: String?
        public let networks: [Network]?
        public let genres: [Genre]?
        public let popularity: Double?
        public var defaultImage: String? { backdropPath }
        public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.backdropSizes }
    }
}
