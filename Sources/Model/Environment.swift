//
//  Environment.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public protocol EntityType {}

public protocol Environment {
    var traktBaseURL: URL { get }
    var traktRedirectURI: String { get }
    var traktClientID: String { get }
    var traktClientSecret: String { get }
    var tmdbBaseURL: URL { get }
    var tmdbAPIKey: String { get }
    var debugEnabled: Bool { get }
}

public struct Configuration {

    private static var _environment: Environment!
    public static var environment: Environment {
        get { return _environment }
        set { _environment = newValue }
    }
}

extension DependencyContainer {
    subscript<T>(index: Key) -> T {
        guard let element: T = resolve(index) else {
            fatalError("No dependency found for \(index)")
        }
        return element
    }
}
