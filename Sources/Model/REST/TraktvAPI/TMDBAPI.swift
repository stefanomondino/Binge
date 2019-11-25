//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

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
