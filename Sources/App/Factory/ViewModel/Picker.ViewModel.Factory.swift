//
//  PickerViewModelFactory.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxRelay
import RxSwift

protocol PickerViewModelFactory {
    func email(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType
    func password(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType
}

struct DefaultPickerViewModelFactory: PickerViewModelFactory {
    let container: RootContainer
    let validator: Validator = DefaultValidator()

    func email(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType {
        let info = FormAdditionalInfo(title: .just(title), errorString: .just(""), keyboardType: .email)
        return StringPickerViewModel(relay: relay, info: info) {
            self.validator.validate($0, for: .email)
        }
    }

    func password(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType {
        let info = FormAdditionalInfo(title: .just(title), errorString: .just(""), keyboardType: .password)
        return StringPickerViewModel(relay: relay, info: info) {
            self.validator.validate($0, for: .password)
        }
    }
}
