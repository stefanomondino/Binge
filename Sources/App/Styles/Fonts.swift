//
//  Fonts.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

enum Fonts {
    case mainRegular
    case mainBold
    
    var fontName: String {
        switch self {
        case .mainRegular: return "Livvic-Regular"
        case .mainBold: return "Livvic-Bold"
        }
    }
}
