//
//  TextStyle.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import SwiftRichString
import UIKit

typealias StyleProtocol = SwiftRichString.StyleProtocol

struct DefaultTextStyle: TextStyle {
//    let size: CGFloat
//    let cornerRadius: CGFloat
//    var color: Color
    var backgroundColor: UIColor { .clear }
    private(set) var style: StyleProtocol

    init(size: CGFloat = 14,
         color: Color = .mainText,
         font: Fonts = .mainRegular,
         alignment: NSTextAlignment = .center) {
        style = SwiftRichString.Style {
            $0.font = UIFont(name: font.fontName, size: size)
            $0.color = color
            $0.lineBreakMode = .byTruncatingTail
            $0.alignment = alignment
        }
    }

    init(style: SwiftRichString.Style) {
        self.style = style
    }
}
