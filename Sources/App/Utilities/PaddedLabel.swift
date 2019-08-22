//
//  PaddedLabel.swift
//  App
//
//  Created by Andrea Lucibello on 17/05/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import SnapKit
import pop

class PaddedLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            bottomInset = newValue.bottom
            leftInset = newValue.left
            rightInset = newValue.right
        }
    }
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: insets)
        super.drawText(in: newRect)
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let boundsWithInset = bounds.inset(by: insets)
        let superRect = super.textRect(forBounds: boundsWithInset, limitedToNumberOfLines: numberOfLines)
        return superRect
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if self.styledText == nil || styledText?.count == 0 {
            return size
        }
        size.height += topInset + bottomInset
        size.width += leftInset + rightInset
        return size
    }
}
