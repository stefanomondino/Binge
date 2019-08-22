//
//  PaddedTextField.swift
//  App
//
//  Created by Flavio Alescio on 13/11/2018.
//  Copyright © 2018 Synesthesia. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    static func allPadded(with padding: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    static func padding(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

class PaddedTextField: UITextField {
    
    var inset: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: inset)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: inset)
    }

}
