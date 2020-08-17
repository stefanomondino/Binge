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
        case seasons

        var title: Translation {
            switch self {
            case .cast: return Strings.Generic.cast
            case .relatedShows: return Strings.Shows.related
            case .seasons: return Strings.Shows.seasons
            }
        }
    }

    case show
    case header
    case loadMore
    case stringPicker
    case carousel
    case person
    case season
    case image
    case description
    // MURRAY PLACEHOLDER

    var identifierString: String {
        return rawValue
    }
}
