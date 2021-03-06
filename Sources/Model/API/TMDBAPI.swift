//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya

struct API {
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let headers: [String: String]?
    let parameters: [String: Any]

    init(baseURL: URL,
         path: String,
         method: Moya.Method = .get,
         headers: [String: String]?,
         parameters: [String: Any]) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
}

public extension TMDB {
    struct Image: Codable {
        let baseUrl: URL
        let secureBaseUrl: URL
        let backdropSizes: [String]
        let posterSizes: [String]
        let profileSizes: [String]
        let stillSizes: [String]
    }
}

extension TMDB {
    enum API {
        struct Configuration: Codable {
            let images: Image
        }

        case configuration
        case show(TraktItem)
        case movie(TraktItem)
        case person(Trakt.Person)
        case seasonDetail(TMDB.Season.Info, TraktShowItem)
        case episode(Trakt.Episode, TraktShowItem)
    }
}

extension TMDB.API: TargetType {
    var baseURL: URL {
        return Model.Configuration.environment.tmdbBaseURL
    }

    var path: String {
        switch self {
        case .configuration: return "configuration"
        case let .show(show): return "tv/\(show.ids.tmdb ?? -1)"
        case let .movie(movie): return "movie/\(movie.ids.tmdb ?? -1)"
        case let .person(person): return "person/\(person.ids.tmdb ?? -1)"
        case let .seasonDetail(season, show): return "tv/\(show.item.ids.tmdb ?? -1)/season/\(season.seasonNumber)"
        case let .episode(episode, show): return "tv/\(show.item.ids.tmdb ?? -1)/season/\(episode.season)/episode/\(episode.number)"
        }
    }

    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any] {
        var parameters = ["api_key": Model.Configuration.environment.tmdbAPIKey]
        switch self {
        case .person, .seasonDetail: parameters["append_to_response"] = "images"
        default: break
        }
        return parameters
    }

    var cacheTime: TimeInterval {
        return 15.minutes
    }
}
