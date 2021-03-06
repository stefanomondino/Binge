//
//  View.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Boomerang
import Foundation

enum ViewIdentifier: String, LayoutIdentifier, CaseIterable {
    enum Supplementary: String {
        case parallax

        var identifierString: String { rawValue }
    }

    enum CarouselType: String {
        case cast
        case relatedShows
        case castInShow
        case castInMovie
        case seasons
        case episodes

        var title: Translation {
            switch self {
            case .cast: return Strings.Generic.cast
            case .castInShow: return Strings.Shows.title
            case .castInMovie: return Strings.Movies.title
            case .relatedShows: return Strings.Shows.related
            case .seasons: return Strings.Shows.seasons
            case .episodes: return Strings.Shows.seasons
            }
        }
    }

//    case show
//    case header
    case loadMore
    case stringPicker
    case carousel
    case person
    case season
    case image
    case description
    case profileHeader
    case button
    case genresStats
    // MURRAY PLACEHOLDER

    var identifierString: String {
        return rawValue
    }
}
