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
}

enum Strings {
    enum Shows: String, Translation {
        case watched = "shows.watched"
        case popular = "shows.popular"
        case trending = "shows.trending"
    }
}
