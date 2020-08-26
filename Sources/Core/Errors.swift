//
//  Errors.swift
//  App
//
//  Created by Stefano Mondino on 15/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxRelay
import RxSwift

public protocol ConcreteError {
    var message: String { get }
}

public enum Errors: Error {
    case generic
    case notLogged
    case invalidUsername
    case invalidPassword
    case unknown(Swift.Error)
    case concrete(ConcreteError)

    var message: String {
        switch self {
        case let .unknown(error): return error.localizedDescription
        case let .concrete(error): return error.message
        default: return localizedDescription
        }
    }
}

public protocol ErrorStatusHandler {
    func clearError()
    func onError(error: Errors)
}

extension ObservableType where Element == Int {
    public var becomesZero: Observable<Bool> {
        map { $0 == 0 }.distinctUntilChanged()
    }

    public var isLoading: Observable<Bool> {
        becomesZero.map { !$0 }
    }
}

public extension Observable {
    func bindingErrorStatus(to handler: ErrorStatusHandler) -> Observable<Element> {
        return self.do(onNext: { _ in handler.clearError() },
                       onError: { handler.onError(error: $0 as? Errors ?? .unknown($0)) },
                       onSubscribed: { handler.clearError() },
                       onDispose: { handler.clearError() })
    }

    func bindingErrorStatus(to handler: BehaviorRelay<Errors?>) -> Observable<Element> {
        return self.do(onNext: { [weak handler] _ in handler?.accept(nil) },
                       onError: { [weak handler] in handler?.accept($0 as? Errors ?? .unknown($0)) },
                       onSubscribed: { [weak handler] in handler?.accept(nil) },
                       onDispose: { [weak handler] in handler?.accept(nil) })
    }

    func bindingErrorStatus(to handler: PublishRelay<Route>, withRoute routeClosure: @escaping (Errors) -> Route?) -> Observable<Element> {
        return self.do(
            onError: { [weak handler] error in
                let validError = error as? Errors ?? Errors.unknown(error)
                if let route = routeClosure(validError) {
                    handler?.accept(route)
                }
            })
    }
}
