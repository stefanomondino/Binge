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
    func showsPager() -> PagerViewModel
    func homePager() -> PagerViewModel
    func showDetail(for show: WithShow) -> ShowDetailViewModel
    //MURRAY DECLARATION PLACEHOLDER
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    
    let container: AppDependencyContainer
    
    func showsPager() -> PagerViewModel {
        return PagerViewModel(pages:[
            popularShows(),
            trendingShows(),
            watchedShows(),
            login()
        ], styleFactory: container.styleFactory)
        .with(Strings.Shows.popular.translation, to: \.pageTitle)
    }
    func homePager() -> PagerViewModel {
        return PagerViewModel(pages:[
            showsPager(),
            login()
        ],
                              layout: SceneIdentifier.tab,
                              styleFactory: container.styleFactory)
    }
    func login() -> LoginViewModel {
        return LoginViewModel(itemFactory: container.pickerViewModelFactory)
    }
    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.useCases.splash)
    }
    
    func popularShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.popularShows,
                          styleFactory: container.styleFactory,
                          routeFactory: container.routeFactory)
    }
    
    func trendingShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.trendingShows,
                          styleFactory: container.styleFactory,
                          routeFactory: container.routeFactory)
    }
    
    func watchedShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.watchedShows,
                          styleFactory: container.styleFactory,
                          routeFactory: container.routeFactory)
    }
    
    func showDetail(for show: WithShow) -> ShowDetailViewModel {
        ShowDetailViewModel(show: show,
                            itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.showDetail,
                          styleFactory: container.styleFactory)
    }

    //MURRAY IMPLEMENTATION PLACEHOLDER
}
