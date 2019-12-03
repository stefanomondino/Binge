//
//  PickerViewModelFactory.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxRelay
import RxSwift

public protocol PickerViewModelFactory {
    func email(relay: BehaviorRelay<String?>, layout: LayoutIdentifier, title: String) -> FormViewModelType
    func password(relay: BehaviorRelay<String?>, layout: LayoutIdentifier, title: String) -> FormViewModelType
}

public extension PickerViewModelFactory {
    func email(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType {
        return email(relay: relay, layout: ViewIdentifier.stringPicker, title: title)
    }
    func password(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType {
        return email(relay: relay, layout: ViewIdentifier.stringPicker, title: title)
    }
}

struct DefaultPickerViewModelFactory: PickerViewModelFactory {
    
    func email(relay: BehaviorRelay<String?>, layout: LayoutIdentifier, title: String) -> FormViewModelType {
            let info = FormAdditionalInfo(title: .just(title), errorString: .just(""), keyboardType: .email)
            return StringPickerViewModel(relay: relay, layout: layout, info: info)
    }
    
    func password(relay: BehaviorRelay<String?>, layout: LayoutIdentifier, title: String) -> FormViewModelType {
            let info = FormAdditionalInfo(title: .just(title), errorString: .just(""), keyboardType: .password)
            return StringPickerViewModel(relay: relay, layout: layout, info: info)
    }
}
