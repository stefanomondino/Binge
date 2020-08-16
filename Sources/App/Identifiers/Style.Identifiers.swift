//
//  Style.Identifiers.swift
//  Skeleton
//
//  Created by Stefano Mondino on 06/07/2020.
//

import Foundation

protocol Style {
    var identifier: String { get }
}

extension Style where Self: RawRepresentable, Self.RawValue == String {
    var identifier: String { rawValue }
}

enum Styles {
    static var allCases: [Style] {
        [Generic.self].flatMap { $0.allCases }
    }

    enum Generic: String, Style, CaseIterable {
        case title
        case container
        case subtitle
        case card
        case navigationBar
        case carouselTitle
    }

    enum Show: String, Style, CaseIterable {
        case titleCard
        case itemTitle
        case itemSubtitle
    }
}
