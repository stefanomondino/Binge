//
//  Scene.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Boomerang
import Foundation

enum SceneIdentifier: String, LayoutIdentifier {
    case splash
    case pager
    case tab
    case login
    case showList
    case showDetail
    case person
    // MURRAY ENUM PLACEHOLDER

    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}
