//
//  Geometry+Extension.swift
//  Core
//
//  Created by Stefano Mondino on 17/08/2020.
//

import CoreGraphics
import Foundation

public extension CGSize {
    var area: CGFloat {
        width * height
    }

    var isEmpty: Bool {
        area <= 0
    }
}

public extension CGRect {
    var area: CGFloat { size.area }

    var isEmpty: Bool { size.isEmpty }
}
