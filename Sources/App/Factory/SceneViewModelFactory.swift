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
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    
    let container: AppDependencyContainer
    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.splashUseCase)
    }
//    func popularShows() -> ShowListViewModel {
//        return ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory) { current, total in
//            return self.container.model.showListUseCase.popular(currentPage: current, pageSize: total).map { $0 }
//        }
//    }
    func popularShows() -> ShowListViewModel {
        return ShowListViewModel(itemViewModelFactory: container.itemViewModelFactory, useCase: container.model.showListUseCase)
    }
//    func schedule() -> ListViewModel & NavigationViewModel {
//        return ScheduleViewModel(itemViewModelFactory: container.itemViewModelFactory, routeFactory: container.routeFactory)
//    }
//    func showDetail(show: Show) -> ShowDetailViewModel {
//        return ShowDetailViewModel(show: show)
//    }
}
