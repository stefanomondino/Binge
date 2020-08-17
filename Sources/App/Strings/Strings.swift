//
//  Strings.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

protocol Translation: CustomStringConvertible {
    var key: String { get }
}

extension Translation where Self: RawRepresentable, RawValue == String {
    var key: String { return rawValue }
    var description: String { return translation }
    func format(with arguments: String) -> String {
        return String(format: description, arguments)
    }

    func format(with arguments: [String]) -> String {
        return String(format: description, arguments)
    }
}

enum Strings {
    enum Generic: String, Translation {
        case cast = "generic.cast"
    }

    enum Shows: String, Translation {
        case shows = "shows.title"
        case related = "shows.related"
        case watched = "shows.watched"
        case popular = "shows.popular"
        case collected = "shows.collected"
        case anticipated = "shows.anticipated"
        case trending = "shows.trending"
        case seasons = "shows.seasons"
        case episodeCountFormat = "shows.episodeCountFormat"
    }

    enum Movies: String, Translation {
        case movies = "movies.title"
        case related = "movies.related"
        case watched = "movies.watched"
        case popular = "movies.popular"
        case collected = "movies.collected"
        case anticipated = "movies.anticipated"
        case trending = "movies.trending"
    }
}
