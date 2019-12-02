//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model
protocol SceneViewModelFactory {
    //    func schedule() -> ListViewModel & NavigationViewModel
    //    func showDetail(show: Show) -> ShowDetailViewModel
    func splashViewModel() -> SplashViewModel
    func popularShows() -> ShowListViewModel
    func trendingShows() -> ShowListViewModel
    func watchedShows() -> ShowListViewModel
    func showsPager() -> ListViewModel
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    
    let container: AppDependencyContainer
    
    func showsPager() -> ListViewModel {
        return PagerViewModel(pages:[
            popularShows(),
            trendingShows(),
            watchedShows(),
            login()
        ], styleFactory: container.styleFactory)
    }
    func login() -> LoginViewModel {
        return LoginViewModel()
    }
    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.useCases.splash)
    }
    
    func popularShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.popularShows,
                          styleFactory: container.styleFactory)
    }
    
    func trendingShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.trendingShows,
                          styleFactory: container.styleFactory)
    }
    func watchedShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.watchedShows,
                          styleFactory: container.styleFactory)
    }
}
