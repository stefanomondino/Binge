//
//  RouteFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 07/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import UIKit

protocol RouteFactory {
    func restart() -> Route
    func page(from viewModel: ViewModel) -> Route
    func home() -> Route
    func url(for url: URL) -> Route
    func exit() -> CompletableRoute
}

class MainRouteFactory: RouteFactory {
    let container: RootContainer

    init(container: RootContainer) {
        self.container = container
    }

    func url(for url: URL) -> Route {
        return SafariRoute(url: url)
    }

    func exit() -> CompletableRoute {
        return ExitRoute()
    }

    func home() -> Route {
        return RestartRoute {
            NavigationController(rootViewController: self.container.views.scenes.mainTabBar())
        }
    }

    func restart() -> Route {
        return RestartRoute {
            self.container.views.scenes.root()
        }
    }

    func page(from viewModel: ViewModel) -> Route {
        switch viewModel {
        case let viewModel as PagerViewModel:
            return EmptyRoute {
                return self.container.views.scenes.pager(viewModel: viewModel)
                    .inContainer(styleFactory: self.container.styleFactory)
            }

        case let viewModel as LoginViewModel:
            return EmptyRoute {
                self.container.views.scenes
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
