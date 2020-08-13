//
//  View.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Boomerang
import Foundation

enum ViewIdentifier: String, LayoutIdentifier {
    enum Supplementary: String {
        case parallax

        var identifierString: String { rawValue }
    }

    enum CarouselType: String {
        case cast
        case relatedShows
    }

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
