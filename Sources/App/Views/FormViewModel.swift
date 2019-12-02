//
//  FormViewModel.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import RxCocoa

protocol FormViewModel: ViewModel {
    associatedtype Value: Hashable, CustomStringConvertible
    var validate: (Value) -> Error? { get }
    var value: BehaviorRelay<Value> { get }
    var textValue: Driver<String> { get }
    var errors: Observable<Error?> { get }
}

extension FormViewModel {
    
    var textValue: Driver<String> {
        return value.asDriver().map { $0.description }
    }
    var errors: Observable<Error?> {
        let validation = self.validate
        return value.asObservable().map { validation($0) }
    }
}

class StringPickerViewModel: FormViewModel {
    
    let value: BehaviorRelay<String>
    let validate: (String) -> Error? = { _ in nil }
    let layoutIdentifier: LayoutIdentifier
    
    init(relay: BehaviorRelay<String>,
         layout: LayoutIdentifier = ViewIdentifier.stringPicker,
         validating validate: @escaping (String) -> Error? = {_ in nil } ) {
        self.value = relay
        self.validate = validate
        self.layoutIdentifier = layout
    }
    
}
