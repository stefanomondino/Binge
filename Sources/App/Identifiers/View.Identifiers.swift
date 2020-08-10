//
//  View.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Boomerang
import Foundation

enum ViewIdentifier: String, LayoutIdentifier {
    case show
    case header
    case loadMore
    case stringPicker
    case carousel
    case person
    case fanart
    // MURRAY PLACEHOLDER

    var identifierString: String {
        return rawValue
    }
}
