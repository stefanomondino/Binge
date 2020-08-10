//
//  SplashViewModel.swift
//  App
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import JavaScriptCore
import Model
import RxRelay
import RxSwift

class SplashViewModel: ViewModel, RxNavigationViewModel {
    var uniqueIdentifier: UniqueIdentifier = UUID()

    var routes: PublishRelay<Route> = PublishRelay()

    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.splash

    let routeFactory: RouteFactory
    let useCase: SplashUseCase

    var disposeBag = DisposeBag()

    init(routeFactory: RouteFactory, useCase: SplashUseCase) {
        self.routeFactory = routeFactory
        self.useCase = useCase
    }

    func start() {
        disposeBag = DisposeBag()
        let factory = routeFactory
        useCase
            .start()
            .take(1)
            .map { factory.home() }
            .bind(to: routes)
            .disposed(by: disposeBag)
    }
}
