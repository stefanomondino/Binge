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

public class SplashViewModel: ViewModel, RxNavigationViewModel {
    public var routes: PublishRelay<Route> = PublishRelay()
    
    public var layoutIdentifier: LayoutIdentifier = CoreSceneIdentifier.splash
    
    let routeFactory: CoreRouteFactory
    let useCase: SplashUseCase
    
    var disposeBag = DisposeBag()
    
    public init(routeFactory: CoreRouteFactory, useCase: SplashUseCase) {
        self.routeFactory = routeFactory
        self.useCase = useCase
    }
    
    public func start() {
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
