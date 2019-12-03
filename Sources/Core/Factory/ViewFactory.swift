//
//  ViewFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

public enum ViewIdentifier: String, LayoutIdentifier {

    case header
    case loadMore
    case stringPicker
    
    public var identifierString: String {
        return self.rawValue
    }
}

