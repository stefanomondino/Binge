//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

enum TraktvAPI {
    
    struct Page {
        var page: Int
        var limit: Int
    }
    
    case trending(Page)
    case popular(Page)
    case played(Page)
    case watched(Page)
    case collected(Page)
    
    case summary(Show)
}
