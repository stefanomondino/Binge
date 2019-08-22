//
//  Environment.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol Environment {
    //Define here read-only variables for viewModel
}

public struct Configuration {
    public static var environment: Environment!
}
