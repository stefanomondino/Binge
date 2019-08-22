//
//  PlaceholderTextView.swift
//  App
//
//  Created by Flavio Alescio on 14/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    var lightColor: UIColor = UIColor.lightGray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        tintColor = UIColor.lightGray
        textColor = tintColor
        self.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    override var text: String! {
        get {
            self.isShowingPlaceholder = attributedText.string == placeholder
            return attributedText.string
        }
        set {
            if !newValue.isEmpty {
                self.attributedText = NSAttributedString(string: newValue, attributes: attributes)
            } else {
                var attributes = self.attributes
                attributes[NSAttributedString.Key.foregroundColor] = lightColor
                self.attributedText = NSAttributedString(string: placeholder, attributes: attributes)
            }
        }
    }
    var placeholder: String = ""
    var isShowingPlaceholder = true
    var maxCharacters: Int = Int.max
    
    var attributes: [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: tintColor ?? .black,
            NSAttributedString.Key.font: _font
        ]
        return attributes
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.typingAttributes = attributes
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text == placeholder {
            self.attributedText = NSAttributedString(string: "", attributes: attributes)
        }
        self.isShowingPlaceholder = false
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if text == "" {
            var attributes = self.attributes
            attributes[NSAttributedString.Key.foregroundColor] = lightColor
            self.attributedText = NSAttributedString(string: placeholder, attributes: attributes)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = self.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if currentText == placeholder && text.isEmpty { return false }
        
        if changedText.isEmpty {
            var attributes = self.attributes
            attributes[NSAttributedString.Key.foregroundColor] = lightColor
            self.attributedText = NSAttributedString(string: placeholder, attributes: attributes)
            return false
        } else if currentText == placeholder {
            self.attributedText = NSAttributedString(string: "", attributes: attributes)
        }
        
        if changedText.count > maxCharacters { return false }
        
        return true
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        if self.text == placeholder {
            var rect = super.caretRect(for: self.beginningOfDocument)
            rect.size.height = _font.lineHeight
            return rect
        }
        var rect = super.caretRect(for: position)
        rect.size.height = _font.lineHeight
        return rect
    }
    
    var _font: UIFont {
        get {
            return font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        set {
            font = newValue
        }
    }
}
