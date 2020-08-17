//
//  Style.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Foundation

enum Style: String, CaseIterable {
    case title
    case container
    case subtitle
    case card
    case navigationBar
    case carouselTitle
    case titleCard
    case itemTitle
    case itemSubtitle
    var identifier: String { rawValue }
}
