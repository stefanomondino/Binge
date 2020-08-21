//
//  Season.swift
//  Model
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation
public enum Season {
    public struct Info: Codable, Item, DownloadableImage {
        public let id: Int
        public let name: String
        public let episodeCount: Int?
        public let overview: String
        public let seasonNumber: Int
        public let posterPath: String?
        public var title: String { name }
        public var item: Item { self }
        public var ids: Ids { Ids.empty }
        public var episodes: [Episode]?
        public var aspectRatio: Double { 250 / 375.0 }
        public var defaultImage: String? { posterPath }
        public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.posterSizes }
    }

    public struct Episode: Codable, Item, DownloadableImage {
        public let id: Int
        public let name: String?
        public let episodeNumber: Int?
        public let overview: String?
        public let seasonNumber: Int?
        public let stillPath: String?
        public var title: String { name ?? "" }
        public var item: Item { self }
        public var ids: Ids { Ids.empty }
        public var aspectRatio: Double { 1920 / 1080.0 }
        public var defaultImage: String? { stillPath }
        public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.stillSizes }
    }
}

public extension Season.Info {
    var uniqueIdentifier: String {
        "\(id)"
    }
}
