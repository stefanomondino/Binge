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

enum TMDBAPI {
    struct Image: Codable {
        let baseUrl: URL
        let secureBaseUrl: URL
        let backdropSizes: [String]
        let posterSizes: [String]
        let profileSizes: [String]
        let stillSizes: [String]
    }

    struct Configuration: Codable {
        let images: Image
    }

    case configuration
    case show(Show)
    case person(Person)
}

extension TMDBAPI: TargetType {
    var baseURL: URL {
        return Model.Configuration.environment.tmdbBaseURL
    }

    var path: String {
        switch self {
        case .configuration: return "configuration"
        case let .show(show): return "tv/\(show.ids.tmdb ?? -1)"
        case let .person(person): return "person/\(person.ids.tmdb ?? -1)"
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
        let parameters = ["api_key": Model.Configuration.environment.tmdbAPIKey]
        switch self {
        default: return parameters
        }
    }
}
