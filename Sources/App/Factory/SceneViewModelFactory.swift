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
    func showListViewModel() -> ShowListViewModel
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    
    let container: AppDependencyContainer
    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.splashUseCase)
    }
    func showListViewModel() -> ShowListViewModel {
        return ShowListViewModel(useCase: container.model.showListUseCase, itemViewModelFactory: container.itemViewModelFactory)
    }
//    func schedule() -> ListViewModel & NavigationViewModel {
//        return ScheduleViewModel(itemViewModelFactory: container.itemViewModelFactory, routeFactory: container.routeFactory)
//    }
//    func showDetail(show: Show) -> ShowDetailViewModel {
//        return ShowDetailViewModel(show: show)
//    }
}
