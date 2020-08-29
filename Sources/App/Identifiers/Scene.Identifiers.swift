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
    case smallPager
    case bigPager
    case tab
    case login
    case itemList
    case itemDetail
    case person
    case search
    case settings
    case settingsList
    // MURRAY ENUM PLACEHOLDER

    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}
