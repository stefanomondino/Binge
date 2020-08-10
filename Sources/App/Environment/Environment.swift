//
//  Environment.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Model

protocol Environment: Model.Environment {}

#if STAGING
    typealias MainEnvironment = StagingEnvironment
#else
    typealias MainEnvironment = StagingEnvironment
#endif
