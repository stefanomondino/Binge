//
//  Fonts.swift
//  App
//
//  Created by Alberto Bo on 12/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftRichString

enum Fonts: FontConvertible {
    
    case main(UIFont.Weight)
    case secondary(UIFont.Weight)
    ///IMPORTANT! remember to include fonts in Info.plist!
    var fontName: String? {
        //TODO remove
        return nil
        switch self {
            
        case .main(let weight):
            switch weight {
            case .bold: return "Helvetica-Bold"
            default: return "Helvetica-Regular"
        }
            
        default: return nil
        }
    }
    var weight: UIFont.Weight {
        switch self {
        case .main(let w), .secondary(let w): return w
        }
    }
    func font(size: CGFloat?) -> Font {
        return fontName?.font(size: size) ?? UIFont.systemFont(ofSize: size ?? 10, weight: weight)
    }
}
