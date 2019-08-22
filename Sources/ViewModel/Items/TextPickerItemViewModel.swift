//
//  TextPickerItemViewModel.swift
//  ViewModel
//
//  Created by Stefano Mondino on 10/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxCocoa

public enum TextTheme {
    case standard
}

public enum InputType {
    case text
    case firstName
    case lastName
    case mobilePhone
    case email
    case username
    case password
    case otp
    case newPassword
    case newEmail
    
    public var isSecure: Bool {
        switch self {
        case .password, .newPassword, .otp: return true
        default: return false
        }
    }
}

open class TextPickerItemViewModel: PickerItemViewModel, FocusablePickerType {
    
    public typealias T = String
    public internal(set) var previousFocusAction: FocusAction = {}
    public internal(set) var nextFocusAction: FocusAction = {}
    public var focus: BehaviorRelay<()> = BehaviorRelay(value: ())
    public var isLast: Bool = true
    public var isFullscreen: Bool = false
    public var title: String = ""
    public var placeholder: String = ""
    public var enabledIf: Observable<Bool> = .just(true)
    public var value: BehaviorRelay<T> { return self.relay as? BehaviorRelay<T> ?? BehaviorRelay(value: "")}
    
    public var externalSelection: Selection?
    
    private let relay: BehaviorRelay<T>
    
    public var selection: Selection = .empty
    public var identifier: Identifier = Identifiers.Views.textPicker
    
    public internal(set) var error: ObservableError = .just(nil)
    
    public var theme: TextTheme = .standard
    public var inputType: InputType = .text
    
    public let isCurrentlySecured = BehaviorRelay(value: false)
    
    init(relay: BehaviorRelay<String>) {
        self.relay = relay
        self.selection = defaultSelection()
    }
    func with(inputType: InputType) -> Self {
        self.inputType = inputType
        isCurrentlySecured.accept(inputType.isSecure)
        return self
    }
    func with(theme: TextTheme) -> Self {
        self.theme = theme
        return self
    }
    func with(fullscreen: Bool) -> Self {
        self.isFullscreen = fullscreen
        return self
    }
    func with(enabledIf: Observable<Bool>) -> Self {
        self.enabledIf = enabledIf
        return self
    }
    func clear() {
        value.accept("")
    }
}
