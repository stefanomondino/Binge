//
//  Styles.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftRichString

enum Styles: String, CaseIterable {
    case title
    case subtitle
    case card
    var identifier: String {
        return rawValue
    }
}

protocol GenericStyle {
    var backgroundColor: UIColor { get }
    var cornerRadius: CGFloat { get }
    var style: StyleProtocol? { get }
}

struct CardStyle: GenericStyle {
    var style: StyleProtocol?
    var backgroundColor: UIColor { .blue }
    let cornerRadius: CGFloat = 8
}

struct TitleStyle: GenericStyle {
    let size: CGFloat
    let cornerRadius: CGFloat
    var backgroundColor: UIColor { .clear }
    var style: StyleProtocol? {
        Style {
            $0.font = UIFont.systemFont(ofSize: self.size)
            $0.color = UIColor.green
            $0.alignment = .center
        }
    }
    init(size: CGFloat = 14,
         cornerRadius: CGFloat = 0) {
        self.size = size
        self.cornerRadius = cornerRadius
    }
}
