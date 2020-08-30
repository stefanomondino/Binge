//
//  Movie.swift
//  Binge
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation

public protocol TraktMovieItem: TraktItemContainer {}

// public protocol MovieDetail: ItemDetail, MovieItem {
//    var info: Movie.Info? { get }
// }
public extension Trakt {
    enum Movie {}
}

public extension TMDB {
    enum Movie {}
}

public extension Trakt.Movie {
    internal struct Item: TraktMovieItem, TraktItem {
        public let title: String
        let ids: Trakt.Ids
        let year: Int?
        public var item: TraktItem { self }
        public var movie: TraktMovieItem { self }
    }

    struct Trending: TraktWatchedItem, Codable, TraktMovieItem {
        private enum CodingKeys: String, CodingKey {
            case movieItem = "movie"
            case watchers
        }

        public static var demo: Trending {
            return Trending(movieItem: Item(title: "Test", ids: Trakt.Ids(trakt: 0, slug: "this-is-test"), year: 2000), watchers: 2)
        }

        private let movieItem: Item
        private let watchers: Int
        public var watcherCount: Int { watchers }
        public var item: TraktItem { return movieItem }
    }

    struct Played: TraktWatchedItem, TraktPlayedItem, TraktCollectedItem, Codable, TraktMovieItem {
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
        private let movieItem: Item
        public var item: TraktItem { return movieItem }
    }

    struct Anticipated: TraktAnticipatedItem, Codable, TraktMovieItem {
        private enum CodingKeys: String, CodingKey {
            case movieItem = "movie"
            case listCount
        }

        private let movieItem: Item
        public let listCount: Int
        public var item: TraktItem { movieItem }
    }

    struct Cast: TraktCastItem, Codable, TraktMovieItem {
        struct Response: Codable {
            let cast: [Cast]
        }

        private enum CodingKeys: String, CodingKey {
            case movieItem = "movie"
            case characters
        }

        private let movieItem: Item
        public let characters: [String]
        public var item: TraktItem { movieItem }
        public var movie: TraktMovieItem { movieItem }
    }

//    public struct Searched: SearchableItem, MovieItem {
//        public let score: Double
//        public let item: Item
//    }

    struct Detail: TraktMovieItem, TraktItemDetail {
        public var overview: String
        public var runtime: Int
        public var title: String
        public var year: Int?
        public var ids: Trakt.Ids
        public var info: TMDB.Movie.Info?
        public var movie: TraktMovieItem { self }
        public var item: TraktItem { self }
    }
}

public extension TMDB.Movie {
    struct Info: Codable, DownloadableImage {
        public var id: Int
        public var uniqueIdentifier: String { "\(id)" }
        public let name: String
        public let backdropPath: String?
        public let posterPath: String?
        public var aspectRatio: Double { 9 / 16 }
        public var defaultImage: String? { backdropPath }
        public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.backdropSizes }
    }
}
