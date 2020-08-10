//
//  Model.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

struct StagingEnvironment: Environment {
    
    var baseURL: URL { URL(string: "https://www.google.com")! }

    var fanartAPIKey: String { Secrets.fanartAPIKey }
    
    var traktBaseURL: URL { URL(string: "https://api.trakt.tv")! }
    
    var traktWebURL: URL { URL(string: "https://trakt.tv")! }
    
    var tmdbAPIKey: String { Secrets.tmdbAPIKey }
    
    var traktClientID: String { Secrets.traktClientID }
    
    var traktRedirectURI: String { Secrets.traktRedirectURI }
    
    var tmdbBaseURL: URL { URL(string: "https://api.themoviedb.org/3/")! }
    
    var fanartBaseURL: URL { URL(string: "https://webservice.fanart.tv/v3")! }
    
    var traktClientSecret: String { Secrets.traktClientSecret }
    
}
