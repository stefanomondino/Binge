//
//
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

public protocol ItemContainer {
    var item: Item { get }
}

public protocol SearchableItem: ItemContainer {
    var score: Double { get }
}

public protocol AnticipatedItem: ItemContainer {
    var listCount: Int { get }
}

public protocol CastItem: ItemContainer {
    var characters: [String] { get }
}

public protocol PlayedItem: ItemContainer {
    var playCount: Int { get }
}

public protocol CollectedItem: ItemContainer {
    var collectedCount: Int { get }
    var collectorCount: Int? { get }
}

public protocol WatchedItem: ItemContainer {
    var watcherCount: Int { get }
}

public protocol Item: Codable, ItemContainer {
    var title: String { get }
    var ids: Ids { get }
    var uniqueIdentifier: String { get }
}

public protocol ItemDetail: Item, DownloadableImage {
    var overview: String { get }
//    var runtime: Int { get }
}

public struct Ids: Codable {
    let trakt: Int
    let slug: String
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

public extension Item {
    var uniqueIdentifier: String {
        "\(ids.trakt)"
    }
}

public protocol DownloadableImage {
    var aspectRatio: Double { get }
    var uniqueIdentifier: String { get }
    var defaultImage: String? { get }
    var allowedSizes: KeyPath<TMDB.Image, [String]> { get }
}
