//
//  Loading.swift
//  BingeTests_iOS
//
//  Created by Stefano Mondino on 26/08/2020.
//

import Foundation
import RxRelay
import RxSwift

public protocol LoadingStatusHandler {
    func onStart()
    func onComplete()
}

public extension Observable {
    func bindingLoadingStatus(to handler: LoadingStatusHandler) -> Observable<Element> {
        return self.do(onSubscribed: { handler.onStart() },
                       onDispose: { handler.onComplete() })
    }

    func bindingLoadingStatus(to handler: BehaviorRelay<Bool>) -> Observable<Element> {
        return self.do(onSubscribed: { [weak handler] in handler?.accept(true) },
                       onDispose: { [weak handler] in handler?.accept(false) })
    }

    func bindingLoadingStatus(to handler: BehaviorRelay<Int>) -> Observable<Element> {
        return self.do(onSubscribed: { [weak handler] in
                           guard let handler = handler else { return }
                           handler.accept(handler.value + 1)
                       },
                       onDispose: { [weak handler] in
                           guard let handler = handler else { return }
                           handler.accept(max(handler.value - 1, 0))
                       })
    }
}
