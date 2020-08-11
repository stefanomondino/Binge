//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya

enum FanartAPI {
    case show(Show)
}

extension FanartAPI: TargetType {
    var baseURL: URL {
        return Model.Configuration.environment.fanartBaseURL
    }

    var path: String {
        switch self {
        case let .show(show): return "tv/\(show.ids.tvdb ?? -1)"
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
        return ["api-key": Model.Configuration.environment.fanartAPIKey]
    }

    var parameters: [String: Any] {
        return [:]
    }

    var cacheTime: TimeInterval {
        return 60.minutes
    }
}
