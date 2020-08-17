//
//  Style.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Foundation

enum Style: String, CaseIterable {
    enum Tag: String {
        case bold = "b"
    }

    case title
    case container
    case subtitle
    case card
    case navigationBar
    case carouselTitle
    case titleCard
    case itemTitle
    case itemSubtitle
    case episodeTitle
    var identifier: String { rawValue }
}

extension CustomStringConvertible {
    func inTag(_ tag: Style.Tag) -> String {
        return "<\(tag.rawValue)>\(self)</\(tag.rawValue)>"
    }
}
