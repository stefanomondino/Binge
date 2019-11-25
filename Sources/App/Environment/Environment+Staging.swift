//
//  Model.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

//#if STAGING
struct StagingEnvironment: Environment {
    
    var baseURL: URL { URL(string: "https://www.google.com")! }

    var debugEnabled: Bool { true }
    
    var traktBaseURL: URL { URL(string: "https://api.trakt.tv")! }
    
    var tmdbAPIKey: String { Secrets.tmdbAPIKey }
    
    var traktClientID: String { Secrets.traktClientID }
    
    var traktRedirectURI: String { Secrets.traktRedirectURI }
    
    var tmdbBaseURL: URL { URL(string: "https://api.themoviedb.org/3/")! }
    
    var traktClientSecret: String { Secrets.traktClientSecret }
    
}
//#endif
