//
//  SplashViewModel.swift
//  App
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxRelay
import RxSwift
import Model

class SplashViewModel: ViewModel, RxNavigationViewModel {
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
            .map { factory.homeRoute() }
            .bind(to: routes)
            .disposed(by: disposeBag)
    }
}
