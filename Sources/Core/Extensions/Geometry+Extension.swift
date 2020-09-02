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

    var ratio: CGFloat {
        if isEmpty { return 0 }
        return width / height
    }
}

public extension CGRect {
    var area: CGFloat { size.area }

    var ratio: CGFloat { size.ratio }

    var isEmpty: Bool { size.isEmpty }
}
