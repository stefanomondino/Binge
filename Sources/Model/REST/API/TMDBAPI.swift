//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya

enum TMDBAPI {
    struct Configuration: Codable {
        let images: Image
        struct Image: Codable {
            let baseUrl: URL
            let secureBaseUrl: URL
            let backdropSizes: [String]
            let posterSizes: [String]
        }
    }
    
    case configuration
    case show(Show)

}

extension TMDBAPI: TargetType {
    var dependencyKey: Int { return cacheKey.hashValue }
    var cacheKey: String {
        return [baseURL.absoluteString,path,method.rawValue, parameters.map { $0.key }.joined()].joined()
    }
    
    var baseURL: URL {
        return Model.Configuration.environment.tmdbBaseURL
    }
    
    var path: String {
        switch self {
        case .configuration: return "configuration"
        case .show( let show ): return "tv/\(show.ids.tmdb ?? -1)"
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
    
    var headers: [String : String]? {
        return nil
    }
    
    private var parameters: [String: Any] {
        let parameters = ["api_key": Model.Configuration.environment.tmdbAPIKey]
        switch self {
            
        default: return parameters
        }
        
    }

}
