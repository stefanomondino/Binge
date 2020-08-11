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
    case trending(Page)
    case popular(Page)
    case played(Page)
    case watched(Page)
    case collected(Page)

    case people(Show)
    case summary(Show)
    case relatedShows(Show)
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
        case .trending: return "shows/trending"
        case .popular: return "shows/popular"
        case .played: return "shows/played"
        case .watched: return "shows/watched"
        case .collected: return "shows/collected"
        case let .summary(show): return "shows/\(show.ids.trakt)"
        case let .people(show): return "shows/\(show.ids.trakt)/people"
        case let .relatedShows(show): return "shows/\(show.ids.trakt)/related"
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
        case let .trending(page),
             let .popular(page),
             let .played(page),
             let .watched(page),
             let .collected(page): return ["page": page.page, "limit": page.limit]
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
        case .summary: return ["extended": "full"]
//        case .search(let q, _):
//            parameters["query"] = q
//            return parameters
//        case .myProfile: return ["extended":"full"]
        default: return parameters
        }
    }
}
