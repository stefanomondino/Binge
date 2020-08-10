//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya

// Please define more than one where needed
enum APIProvider {
    case test
    case login(username: String, password: String)
}

extension APIProvider: TargetType {
    var baseURL: URL {
        return Model.Configuration.environment.baseURL
    }

    var path: String {
        switch self {
        case .login: return "someTestPath"
        case .test: return "schedule"
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
        return [:]
    }

    var parameters: [String: Any] {
        return [:]
    }
}
