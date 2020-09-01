//
//  Season.swift
//  Model
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation

extension Trakt {
    public struct Season: TraktItem, TraktItemContainer {
        public var title: String
        public var item: TraktItem { self }
        public let ids: Trakt.Ids
        public let seasonNumber: Int
    }

    public struct Episode: TraktItem, TraktItemContainer {
        public let season: Int
        public let number: Int
        public let title: String
        public let ids: Ids
        public var item: TraktItem { self }
    }
}

extension TMDB {
    public enum Season {
        public struct Info: Codable, DownloadableImage, GenericItem {
            public let id: Int
            public let name: String
            public let episodeCount: Int?
            public let overview: String
            public let seasonNumber: Int
            public let posterPath: String?
            public var title: String { name }
            public var episodes: [Episode]?
            public var aspectRatio: Double { 250 / 375.0 }
            public var defaultImage: String? { posterPath }
            public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.posterSizes }
            public var uniqueIdentifier: String {
                "\(id)"
            }
        }

        public struct Episode: Codable, DownloadableImage, GenericItem {
            public var uniqueIdentifier: String { "\(id)" }
            public let id: Int
            public let name: String?
            public let episodeNumber: Int?
            public let overview: String?
            public let seasonNumber: Int?
            public let stillPath: String?
            public var title: String { name ?? "" }
            public var aspectRatio: Double { 1920 / 1080.0 }
            public var defaultImage: String? { stillPath }
            public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.stillSizes }
        }
    }
}
