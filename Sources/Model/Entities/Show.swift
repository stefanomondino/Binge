//
//
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public protocol WithShow: EntityType {
    var show: Show { get }
}

public struct TrendingShow: WithShow, Codable {
    public let watchers: Int
    public let show: Show
}

public struct PlayedShow: WithShow {
    public let watcherCount: Int
    public let playCount: Int
    public let collectedCount: Int
    public let collectorCount: Int
    public let show: Show
}

public struct SearchedShow: WithShow {
    public let score: Double
    public let show: Show
}

public struct Show: Codable, WithShow {
    public let title: String
    let ids: Ids
    let year: Int?
    public var show: Show { return self }
    struct Ids: Codable {
        let trakt: Int
        let slug: String
        let tvdb: Int?
        let tmdb: Int?
        let imdb: String?
        let tvrage: Int?
    }
}

public struct ShowInfo: Codable, ModelType {
    let name: String
    let backdropPath: String?
    let posterPath: String?
}
