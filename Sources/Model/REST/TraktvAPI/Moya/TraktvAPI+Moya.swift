//
//  Moya.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya

extension TraktvAPI: TargetType {
    
    var dependencyKey: Int {
        return cacheKey.hashValue
    }
    var cacheKey: String {
        return [baseURL.absoluteString, path, method.rawValue, parameters.map { $0.key + "_\($0.value)" }.joined()].joined()
    }
    var baseURL: URL {
        return Model.Configuration.environment.traktBaseURL
    }
    
    var path: String {
        switch self {
        case .trending: return "shows/trending"
        case .popular: return "shows/popular"
        case .played: return "shows/played"
        case .watched: return "shows/watched"
        case .collected: return "shows/collected"
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
        //case .played(_, let page), .trending(let page), .search(_, let page): return ["page": page.page, "limit": page.limit]
        case .trending(let page),
             .popular(let page),
             .played(let page),
             .watched(let page),
             .collected(let page): return ["page": page.page, "limit": page.limit]
        @unknown default: return [:]
        }
    }
    private var parameters: [String: Any] {
        var parameters = pagination
        switch self {
//        case .search(let q, _):
//            parameters["query"] = q
//            return parameters
//        case .myProfile: return ["extended":"full"]
        @unknown default: return parameters
        }
        
    }

    
}
