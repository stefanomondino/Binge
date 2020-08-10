//
//  FormViewModel.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import RxCocoa
import RxRelay
import RxSwift

protocol FormViewModelType: ViewModel {
    typealias NavigationCallback = () -> Void
    var textValue: Driver<String> { get }
    var additionalInfo: FormAdditionalInfo { get }
    var errors: Observable<Error?> { get }
    var focus: PublishRelay<Void> { get }
    var onNext: NavigationCallback? { get set }
    var onPrevious: NavigationCallback? { get set }
}

protocol FormViewModel: FormViewModelType {
    typealias ValidationCallback = (Value?) -> Error?
    associatedtype Value: Hashable
    var validate: ValidationCallback { get }
    var value: BehaviorRelay<Value?> { get }
}

extension FormViewModel where Value: CustomStringConvertible {
    var textValue: Driver<String> {
        return value.asDriver().map { $0?.description ?? "" }
    }
}

extension FormViewModel {
    var errors: Observable<Error?> {
        let validation = validate
        return value.asObservable().map { validation($0) }
    }
}

enum KeyboardType {
    case email
    case password
    case phone
    case number
    case `default`
}

struct FormAdditionalInfo {
    var title: Observable<String>
    var errorString: Observable<String>
    var keyboardType: KeyboardType
}

extension Array where Element == FormViewModelType {
    func withNavigation(_ confirmation: @escaping FormViewModel.NavigationCallback) -> [FormViewModelType] {
        let elements: [FormViewModelType] = reduce([]) { acc, element -> [FormViewModelType] in
            var accumulator = acc
            if let previous = accumulator.last {
                previous.onNext = { element.focus.accept(()) }
                element.onPrevious = { previous.focus.accept(()) }
            }
            accumulator.append(element)
            return accumulator
        }
        elements.last?.onNext = confirmation
        return elements
    }
}
