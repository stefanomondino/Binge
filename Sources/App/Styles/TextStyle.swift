//
//  TextStyle.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import SwiftRichString

typealias StyleProtocol = SwiftRichString.StyleProtocol

struct TextStyle: GenericStyle {
    let size: CGFloat
    let cornerRadius: CGFloat
    var backgroundColor: UIColor { .clear }
    var style: StyleProtocol? {
        Style {
            $0.font = UIFont.init(name: Fonts.mainBold.fontName, size: self.size)
            $0.color = UIColor.black
            $0.alignment = .center
        }
    }
    init(size: CGFloat = 14,
         cornerRadius: CGFloat = 0) {
        self.size = size
        self.cornerRadius = cornerRadius
    }
}
