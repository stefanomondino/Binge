//
//  RouteFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 07/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit
import Model

protocol RouteFactory {
    var container: AppDependencyContainer { get }
    func restartRoute() -> Route
    func pageRoute(from viewModel: ViewModel) -> Route
    func homeRoute() -> Route
    func showDetailRoute(for show: WithShow) -> Route
    //    func detailRoute(show: Show) -> Route
}
class MainRouteFactory: RouteFactory {
    let container: AppDependencyContainer
    
    init(container: AppDependencyContainer) {
        self.container = container
    }
    func homeRoute() -> Route {
        return RestartRoute {
            UINavigationController(rootViewController: self.container.viewControllerFactory.showPager())
        }
    }
    func restartRoute() -> Route {
        return RestartRoute {
            self.container.viewControllerFactory.root()
        }
    }
    
    func showDetailRoute(for show: WithShow) -> Route {
        return NavigationRoute {
            let viewModel = self.container.sceneViewModelFactory.showDetail(for: show)
            return self.container.viewControllerFactory.showDetail(viewModel: viewModel)
        }
    }
    
    func pageRoute(from viewModel: ViewModel) -> Route {
        switch viewModel {
        case let viewModel as ShowListViewModel:
            return EmptyRoute {
                self.container
                    .viewControllerFactory
                    .showList(viewModel: viewModel)
            }
        case let viewModel as LoginViewModel:
            return EmptyRoute {
                self.container.viewControllerFactory
                    .login(viewModel: viewModel)
            }
        default:
            return EmptyRoute {
                UIViewController()
            }
        }
    }
}

//    func detailRoute(show: Show) -> Route {
//        //return AlertRoute(viewModel: ShowDetailViewModel(show: show))
//        //        return ModalRoute(viewModel: ShowDetailViewModel(show: show), factory: container.viewControllerFactory)
//        return ModalRoute { self.container
//            .viewControllerFactory
//            .showDetail(viewModel: ShowDetailViewModel(show: show))
//        }
//        //return ModalRoute(viewModel: ScheduleViewModel())
//    }
