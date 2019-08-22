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
        return Model.Configuration.environment.baseURL
    }
    
    var path: String {
        switch self {
        case .test: return ""
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
    
    private var parameters: [String: Any] {
        //Place here some default parameters
        return [:]
    }
    
}
