//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
protocol SceneViewModelFactory {
    //    func schedule() -> ListViewModel & NavigationViewModel
    //    func showDetail(show: Show) -> ShowDetailViewModel
    func splashViewModel() -> SplashViewModel
    func homePager() -> PagerViewModel
    func login() -> LoginViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    let container: RootContainer

    func homePager() -> PagerViewModel {
        return PagerViewModel(pages: [
            login()

        ],
                              layout: SceneIdentifier.tab,
                              styleFactory: container.styleFactory)
    }

    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.useCases.splash)
    }

    func login() -> LoginViewModel {
        return LoginViewModel(itemFactory: container.viewModels.pickers,
                              routeFactory: container.routeFactory,
                              styleFactory: container.styleFactory)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
