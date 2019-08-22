//
//  UILabel+Style.swift
//  App
//
//  Created by Alberto Bo on 13/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftRichString
import ViewModel

extension Reactive where Base: UIButton {
   
    func highlightedBackground() -> Binder<UIImage?> {
        return Binder(base) { base, image in
            base.setBackgroundImage(image, for: .normal)
            base.setBackgroundImage(image?.highlighted(), for: .highlighted)
        }
    }
    
    func highlightedImage() -> Binder<UIImage?> {
        return Binder(base) { base, image in
            base.setImage(image, for: .normal)
            base.setImage(image?.highlighted(), for: .highlighted)
        }
    }
    public var styledText: Binder<String?> {
        return Binder(self.base) { base, text in
            let attrString = NSAttributedString(string: text ?? "")
            base.setAttributedTitle(attrString, for: .normal)
        }
    }
}

extension Reactive where Base: UILabel {
    
    public var styledText: Binder<String?> {
        return Binder(self.base) { base, text in
            base.styledText = text
        }
    }
}
