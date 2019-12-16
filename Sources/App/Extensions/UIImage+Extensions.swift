//
//  UIImage+Extensions.swift
//  App
//
//  Created by Stefano Mondino on 16/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func shape(with bezier: UIBezierPath, strokeColor: UIColor = .clear, fillColor: UIColor = .clear, lineWidth: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContext(bezier.bounds.insetBy(dx: lineWidth, dy: lineWidth).size)
        fillColor.setFill()
        bezier.fill()
        strokeColor.setStroke()
        bezier.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
