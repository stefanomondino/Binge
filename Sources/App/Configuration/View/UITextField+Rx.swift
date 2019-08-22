//
//  UITextField+Rx.swift
//  App
//
//  Created by Flavio Alescio on 23/05/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import ViewModel
import SwiftRichString

extension TextTheme {
    
    var fontStyle: Style {
        switch self {
        default : return Identifiers.Styles.mainRegularStyle.style
        }
    }
    
    func placeholderStyle(isEmpty: Bool) -> Style {
        switch self {
        default:
            if isEmpty {
                return Identifiers.Styles.placeholderBig.style
            } else {
                return Identifiers.Styles.placeholderSmall.style
            }
        }
    }
    
    var tintColor: UIColor {
        switch self {
        default : return .blue
        }
    }
    
    var inset: UIEdgeInsets {
        switch self {
        default : return .zero
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        default : return .clear
        }
    }
    
    var barColor: UIColor {
        switch self {
        default : return UIColor.lightGray
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        default : return 0
        }
    }
}

extension Reactive where Base: UITextField {
    var isSecureTextEntry: Binder<Bool> {
        return Binder(base) { base, isSecure in base.isSecureTextEntry = isSecure }
    }
}

extension InputType {
    var keyboardType: UIKeyboardType {
        switch self {
        case .otp:
            return .numberPad
        case .firstName, .lastName:
            return .asciiCapable //.namePhonePad -> NO CAPITALIZATION SUPPORT
        case .mobilePhone:
            return .phonePad
        case .email, .username, .newEmail:
            return .emailAddress
        case .password, .text, .newPassword:
            return .default
        }
    }
    var textContentType: UITextContentType? {
        switch self {
        case .otp:
            if #available(iOS 12.0, *) {
                return .oneTimeCode
            } else {
                return nil
            }
        case .username: return .username
        case .firstName: return .givenName
        case .lastName: return .familyName
        case .mobilePhone: return .telephoneNumber
        case .email, .newEmail: return .emailAddress
        case .password: return .password
        case .newPassword:
            if #available(iOS 12.0, *) {
                return .newPassword
            } else {
                return .password
            }
        case .text: return nil
        }
    }
    var spellCheckingType: UITextSpellCheckingType {
        switch self {
        case .newEmail, .email, .mobilePhone, .password, .newPassword, .firstName, .lastName, .username, .otp:
            return .no
        case .text:
            return .yes
        }
    }
    var autocorrectionType: UITextAutocorrectionType {
        switch self {
        case .newEmail, .email, .mobilePhone, .password, .newPassword, .firstName, .lastName, .username, .otp:
            return .no
        case .text:
            return .yes
        }
    }
    var autocapitalizationType: UITextAutocapitalizationType {
        switch self {
        case .newEmail, .email, .mobilePhone, .password, .newPassword, .username, .otp:
            return .none
        case .firstName, .lastName:
            return .words
        case .text:
            return .sentences
        }
    }
    var smartInsertDeleteType: UITextSmartInsertDeleteType {
        switch self {
        case .newEmail, .email, .mobilePhone, .password, .newPassword, .username, .otp:
            return .no
        case .text, .firstName, .lastName:
            return .yes
        }
    }
}

extension UITextField {
    func setInputType(_ input: InputType) {
        autocapitalizationType = input.autocapitalizationType
        keyboardType = input.keyboardType
        textContentType = input.textContentType
        spellCheckingType = input.spellCheckingType
        autocorrectionType = input.autocorrectionType
        smartInsertDeleteType = input.smartInsertDeleteType
    }
}
