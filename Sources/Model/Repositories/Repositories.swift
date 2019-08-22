//
//  Repositories.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public struct Repositories {
    static var shows: ShowsRepository = ShowsAPIRepository()
    static var configuration: ConfigurationRepository = ConfigurationAPIRepository()
    //MURRAY PLACEHOLDER - DO NOT REMOVE
}
