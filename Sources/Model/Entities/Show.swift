//
//
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public protocol WithShow {
    var show: Show { get }
}

public struct TrendingShow: WithShow, Codable {
    private enum CodingKeys: String, CodingKey {
        case _show = "show"
        case watchers = "watchers"
    }
    private let _show: ShowItem
    public let watchers: Int
    public var show: Show { return _show }
}

public struct PlayedShow: WithShow, Codable {
    private enum CodingKeys: String, CodingKey {
        case _show = "show"
        case watcherCount = "watcherCount"
        case playCount = "playCount"
        case collectedCount = "collectedCount"
        case collectorCount = "collectorcount"
    }
    
    public let watcherCount: Int
    public let playCount: Int
    public let collectedCount: Int
    public let collectorCount: Int
    private let _show: ShowItem
    public var show: Show { return _show }
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
}

public struct Ids: Codable {
    let trakt: Int
    let slug: String
    let tvdb: Int?
    let tmdb: Int?
    let imdb: String?
    let tvrage: Int?
}
public extension Show {
    var uniqueIdentifier: String {
        "\(ids.trakt)"
    }
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
    var show: Show { return self }
}

public struct ShowInfo: Codable {
    let name: String
    let backdropPath: String?
    let posterPath: String?
}
