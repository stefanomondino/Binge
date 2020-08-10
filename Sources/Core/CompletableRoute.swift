//
//  CompletableRoute.swift
//  Core
//
//  Created by Stefano Mondino on 15/07/2020.
//

import Boomerang
import Foundation
import RxRelay
import RxSwift

public protocol CompletableRoute: Route {
    var onCompleteRelay: PublishRelay<Bool> { get }
}

public extension CompletableRoute {
    func onAnimationComplete(_ callback: @escaping (Bool) -> Observable<Route>) -> Observable<Route> {
        return onCompleteRelay
            .asObservable()
            .take(1)
            .flatMap { callback($0) }
            .startWith(self)
    }
}
