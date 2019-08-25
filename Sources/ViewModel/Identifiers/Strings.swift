//
//  Images.swift
//  ViewModel
//
//  Created by Stefano Mondino on 28/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

extension Identifiers {
    
    public enum Strings: String, CaseIterable, DependencyKey {
        
        case test
        case ok
        case username
        case password
        case loading
        case chooseImage
        case camera
        case library
        case cancel
        
        case shows
        case trending
        case popular
        case collected
        case watched
        case played
    }
}
