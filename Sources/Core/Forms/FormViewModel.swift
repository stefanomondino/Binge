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

public protocol FormViewModelType: ViewModel {
    typealias NavigationCallback = () -> ()
    var textValue: Driver<String> { get }
    var additionalInfo: FormAdditionalInfo { get }
    var errors: Observable<Error?> { get }
    var focus: PublishRelay<()> { get }
    var onNext: NavigationCallback? { get set }
    var onPrevious: NavigationCallback? { get set }
}

public protocol FormViewModel: FormViewModelType {
    typealias ValidationCallback = (Value?) -> Error?
    associatedtype Value: Hashable
    var validate: ValidationCallback { get }
    var value: BehaviorRelay<Value?> { get }
}

public extension FormViewModel where Value: CustomStringConvertible {
    var textValue: Driver<String> {
        return value.asDriver().map { $0?.description ?? "" }
    }
}
public extension FormViewModel {
    
    var errors: Observable<Error?> {
        let validation = self.validate
        return value.asObservable().map { validation($0) }
    }
}

public enum KeyboardType {
    case email
    case password
    case phone
    case number
    case `default`
}

public struct FormAdditionalInfo {
    var title: Observable<String>
    var errorString: Observable<String>
    var keyboardType: KeyboardType
}

public extension Array where Element == FormViewModelType {
    func withNavigation(_ confirmation: @escaping FormViewModel.NavigationCallback) -> [FormViewModelType] {
        let elements: [FormViewModelType] = self.reduce([]) { acc, element -> [FormViewModelType] in
            var accumulator = acc
            if let previous = accumulator.last {
                previous.onNext =  { element.focus.accept(()) }
                element.onPrevious = { previous.focus.accept(())}
            }
             accumulator.append(element)
            return accumulator
        }
        elements.last?.onNext = confirmation
        return elements
    }
}
