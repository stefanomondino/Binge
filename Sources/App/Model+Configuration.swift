//
//  Model.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Model
struct ModelEnvironment: Model.Environment {
    
    var baseURL: URL {
        return URL(string: "https://www.google.com")!
    }
    
    var debugEnabled: Bool {
        return true 
    }
    
    var traktBaseURL: URL { return URL(string: "https://api.trakt.tv")! }
    var tmdbAPIKey: String { return Secrets.tmdbAPIKey }
    var traktClientID: String { return Secrets.traktClientID }
    var traktRedirectURI: String { return Secrets.traktRedirectURI }
    var tmdbBaseURL: URL { return URL(string: "https://api.themoviedb.org/3/")! }
    var traktClientSecret: String { return Secrets.traktClientSecret }
    
}
