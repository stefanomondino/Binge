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

    func error(_ error: Errors, retry: (() -> Void)?) -> Route {
        return ErrorRoute(error: error, retry: retry)
    }

    func home() -> Route {
        return RestartRoute {
            self.container.views.scenes
                .mainTabBar()
                .inNavigationController()
//            NavigationController(rootViewController: self.container.views.scenes.mainTabBar())
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
            }
        case let viewModel as ItemListViewModel:
            return EmptyRoute {
                self.container
                    .views
                    .scenes
                    .showList(viewModel: viewModel)
//                    .inContainer()
            }
        case let viewModel as SearchViewModel:
            return EmptyRoute {
                self.container.views.scenes.search(viewModel: viewModel).inContainer()
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

    func showDetail(for show: ItemContainer) -> Route {
        guard let viewModel = container.viewModels.scenes.itemDetail(for: show) else {
            return EmptyRoute { nil }
        }
        return NavigationRoute {
            return self.container.views.scenes
                .itemDetail(viewModel: viewModel)
                .inContainer(extendUnderNavbar: true)
        }
    }

    func personDetail(for person: Person) -> Route {
        return NavigationRoute {
            let viewModel = self.container.viewModels.scenes.personDetail(for: person)
            return self.container.views.scenes
                .itemDetail(viewModel: viewModel)
                .inContainer(extendUnderNavbar: true)
        }
    }

    func seasonDetail(for season: Season.Info, of show: ShowItem) -> Route {
        return NavigationRoute {
            let viewModel = self.container.viewModels.scenes.seasonDetail(for: season, of: show)
            return self.container.views.scenes
                .itemDetail(viewModel: viewModel)
                .inContainer(extendUnderNavbar: true)
        }
    }

    func search() -> Route {
        return NavigationRoute {
            let viewModel = self.container.viewModels.scenes.search()
            return self.container.views.scenes
                .search(viewModel: viewModel)
                .inContainer(extendUnderNavbar: true)
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
