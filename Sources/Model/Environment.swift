//
//  Environment.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public typealias EntityType = ModelType

public protocol Environment {
    var baseURL: URL { get }
    var debugEnabled: Bool { get }
}

public struct Configuration {
    public static var environment: Environment!
}
