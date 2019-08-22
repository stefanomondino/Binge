//
//  Model.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import ViewModel
struct ViewModelEnvironment: ViewModel.Environment, Bootstrappable {
    
    static func bootstrap() {
        Configuration.environment = ViewModelEnvironment()
        switch Environment.current {
        case .devel: ViewModel.Logger.logLevel = .verbose
        case .prod: ViewModel.Logger.logLevel = .none
        }
    }
    
}
