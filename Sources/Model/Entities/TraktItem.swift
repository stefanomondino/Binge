//
//  TraktItem.swift
//  Binge
//
//  Created by Stefano Mondino on 30/08/2020.
//

import Foundation

public enum Trakt {}

extension Trakt {
    public struct Ids: Codable {
        let trakt: Int
        let slug: String?
        let tvdb: Int?
        let tmdb: Int?
        let imdb: String?
        let tvrage: Int?
        static var empty: Ids { .init(trakt: -1, slug: UUID().uuidString) }
        init(trakt: Int, slug: String) {
            self.trakt = trakt
            self.slug = slug
            tvdb = nil
            tmdb = nil
            imdb = nil
            tvrage = nil
        }
    }
}

public protocol GenericItem {
    var uniqueIdentifier: String { get }
    var title: String { get }
}

public protocol TraktItemContainer: GenericItem {
    var item: TraktItem { get }
}

public extension TraktItemContainer {
    var uniqueIdentifier: String { item.uniqueIdentifier }
    var title: String { item.title }
}

public protocol TraktSearchableItem: TraktItemContainer {
    var score: Double { get }
}

public protocol TraktAnticipatedItem: TraktItemContainer {
    var listCount: Int { get }
}

public protocol TraktCastItem: TraktItemContainer {
    var characters: [String] { get }
}

public protocol TraktPlayedItem: TraktItemContainer {
    var playCount: Int { get }
}

public protocol TraktCollectedItem: TraktItemContainer {
    var collectedCount: Int { get }
    var collectorCount: Int? { get }
}

public protocol TraktWatchedItem: TraktItemContainer {
    var watcherCount: Int { get }
}

public protocol TraktItem: Codable, TraktItemContainer {
    var ids: Trakt.Ids { get }
    var uniqueIdentifier: String { get }
}

public protocol TraktItemDetail: TraktItem {
    var overview: String { get }
}

public extension TraktItem {
    var uniqueIdentifier: String {
        "\(ids.trakt)"
    }
}
