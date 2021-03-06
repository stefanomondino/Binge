//
//  Environment.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

public protocol EntityType {}

public protocol Environment {
    var traktBaseURL: URL { get }
    var traktWebURL: URL { get }
    var traktRedirectURI: String { get }
    var traktClientID: String { get }
    var traktClientSecret: String { get }
    var fanartAPIKey: String { get }
    var fanartBaseURL: URL { get }
    var tmdbBaseURL: URL { get }
    var tmdbAPIKey: String { get }
}

public struct Configuration {
    private static var _environment: Environment!
    public static var environment: Environment {
        get { return _environment }
        set { _environment = newValue }
    }
}
