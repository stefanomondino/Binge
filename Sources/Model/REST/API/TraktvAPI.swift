//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya

enum TraktvAPI {
    struct Page {
        var page: Int
        var limit: Int
    }

    case authorize
    case token(code: String)

    case trendingShows(Page)
    case popularShows(Page)
    case playedShows(Page)
    case watchedShows(Page)
    case collectedShows(Page)
    case anticipatedShows(Page)
    case showPeople(Item)
    case seasons(Item)
    case showSummary(Item)
    case relatedShows(Item)

    case trendingMovies(Page)
    case popularMovies(Page)
    case playedMovies(Page)
    case watchedMovies(Page)
    case collectedMovies(Page)
    case anticipatedMovies(Page)
    case moviePeople(Item)
    case movieSummary(Item)
    case relatedMovies(Item)
}

extension TraktvAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .authorize: return Configuration.environment.traktWebURL
        default: return Configuration.environment.traktBaseURL
        }
    }

    var path: String {
        switch self {
        case .authorize: return "oauth/authorize"
        case .token: return "oauth/token"
        case .trendingShows: return "shows/trending"
        case .popularShows: return "shows/popular"
        case .playedShows: return "shows/played"
        case .watchedShows: return "shows/watched"
        case .collectedShows: return "shows/collected"
        case .anticipatedShows: return "shows/anticipated"
        case .trendingMovies: return "movies/trending"
        case .popularMovies: return "movies/popular"
        case .playedMovies: return "movies/played"
        case .watchedMovies: return "movies/watched"
        case .collectedMovies: return "movies/collected"
        case .anticipatedMovies: return "movies/anticipated"
        case let .seasons(show): return "shows/\(show.ids.trakt)/seasons"
        case let .showSummary(show): return "shows/\(show.ids.trakt)"
        case let .movieSummary(movie): return "movies/\(movie.ids.trakt)"
        case let .showPeople(show): return "shows/\(show.ids.trakt)/people"
        case let .moviePeople(movie): return "movies/\(movie.ids.trakt)/people"
        case let .relatedShows(show): return "shows/\(show.ids.trakt)/related"
        case let .relatedMovies(movie): return "movies/\(movie.ids.trakt)/related"
        }
    }

    var method: Moya.Method {
        switch self {
        case .token: return .post
        default: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch method {
        case .post: return Task.requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default: return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        let auth: String?
        if let token = AccessToken.current?.accessToken {
            auth = "Bearer \(token)"
        } else {
            auth = nil
        }
        return [
            "Content-Type": "application/json",
            "trakt-api-version": "2",
            "trakt-api-key": Configuration.environment.traktClientID,
            "Authorization": auth ?? ""
        ]
    }

    private var pagination: [String: Any] {
        switch self {
        // case .played(_, let page), .trending(let page), .search(_, let page): return ["page": page.page, "limit": page.limit]
        case let .trendingShows(page),
             let .popularShows(page),
             let .playedShows(page),
             let .watchedShows(page),
             let .anticipatedShows(page),
             let .collectedShows(page),
             let .trendingMovies(page),
             let .popularMovies(page),
             let .playedMovies(page),
             let .watchedMovies(page),
             let .anticipatedMovies(page),
             let .collectedMovies(page): return ["page": page.page, "limit": page.limit]
        default: return [:]
        }
    }

    var parameters: [String: Any] {
        let parameters = pagination
        switch self {
        case let .token(code):
            return ["code": code,
                    "client_id": Configuration.environment.traktClientID,
                    "client_secret": Configuration.environment.traktClientSecret,
                    "grant_type": "authorization_code",
                    "redirect_uri": Configuration.environment.traktRedirectURI]
        case .authorize: return ["response_type": "code",
                                 "client_id": Configuration.environment.traktClientID,
                                 "redirect_uri": Configuration.environment.traktRedirectURI]
        case .showSummary, .movieSummary: return ["extended": "full"]
        //        case .search(let q, _):
        //            parameters["query"] = q
        //            return parameters
        //        case .myProfile: return ["extended":"full"]
        default: return parameters
        }
    }

    var cacheTime: TimeInterval {
        return 5.minutes
    }
}
