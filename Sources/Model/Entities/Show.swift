//
//
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

public protocol WithShow {
    var show: Show { get }
}

public struct TrendingShow: WithShow, Codable {
    private enum CodingKeys: String, CodingKey {
        case showItem = "show"
        case watchers
    }

    public static var demo: TrendingShow {
        return TrendingShow(showItem: ShowItem(title: "Test", ids: Ids(trakt: 0, slug: "this-is-test"), year: 2000), watchers: 2)
    }

    private let showItem: ShowItem
    public let watchers: Int
    public var show: Show { return showItem }
}

public struct PlayedShow: WithShow, Codable {
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
    public let collectorCount: Int
    private let showItem: ShowItem
    public var show: Show { return showItem }
}

public struct AnticipatedShow: WithShow, Codable {
    private enum CodingKeys: String, CodingKey {
        case showItem = "show"
        case listCount
    }

    private let showItem: ShowItem
    public let listCount: Int
    public var show: Show { showItem }
}

public struct SearchedShow: WithShow {
    public let score: Double
    public let show: Show
}

public protocol Show: Codable, WithShow {
    var title: String { get }
    var year: Int? { get }
    var ids: Ids { get }
    var uniqueIdentifier: String { get }
}

public protocol ShowDetail: Show {
    var overview: String { get }
    var runtime: Int { get }
    var info: ShowInfo? { get }
}

public struct Ids: Codable {
    let trakt: Int
    let slug: String
    let tvdb: Int?
    let tmdb: Int?
    let imdb: String?
    let tvrage: Int?

    init(trakt: Int, slug: String) {
        self.trakt = trakt
        self.slug = slug
        tvdb = nil
        tmdb = nil
        imdb = nil
        tvrage = nil
    }
}

public extension Show {
    var uniqueIdentifier: String {
        "\(ids.trakt)"
    }
}

public struct ShowSeason: Codable {
    let ids: Ids
    let number: Int
}

public struct SeasonInfo: Codable {
    public let id: Int
    public let name: String
    public let episodeCount: Int
    public let overview: String
    public let seasonNumber: Int
    public let posterPath: String?
}

internal struct ShowItem: Show {
    public let title: String
    let ids: Ids
    let year: Int?
    public var show: Show { return self }
}

internal struct ShowDetailItem: ShowDetail {
    var overview: String
    var runtime: Int
    var title: String
    var year: Int?
    var ids: Ids
    var info: ShowInfo?
    var show: Show { return self }
}

public struct ShowInfo: Codable {
    public let name: String
    public let backdropPath: String?
    public let posterPath: String?
    public let seasons: [SeasonInfo]?
}

public extension SeasonInfo {
    var uniqueIdentifier: String {
        "\(id)"
    }
}
