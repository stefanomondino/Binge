//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import UIKit

class DefaultViewControllerFactory: ViewControllerFactory {
    let container: RootContainer

    init(container: RootContainer) {
        self.container = container
    }

    private func name(from layoutIdentifier: LayoutIdentifier) -> String {
        let identifier = layoutIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"
    }

    func root() -> UIViewController {
        return SplashViewController(viewModel: container.viewModels.scenes.splashViewModel())
    }

    func showPager() -> UIViewController {
        let viewModel = container.viewModels.scenes.showsPager()
        return pager(viewModel: viewModel)
    }

    func pager(viewModel: PagerViewModel) -> UIViewController {
        return PagerViewController(viewModel: viewModel, routeFactory: container.routeFactory, styleFactory: container.styleFactory)
    }

    func mainTabBar() -> UIViewController {
        let viewModel = container.viewModels.scenes.homePager()
        return TabViewController(viewModel: viewModel,
                                 routeFactory: container.routeFactory,
                                 styleFactory: container.styleFactory)
    }

    func login(viewModel: LoginViewModel) -> UIViewController {
        return LoginViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   viewModel: viewModel,
                                   collectionViewCellFactory: container.views.collectionCells)
    }

    func showList(viewModel: ItemListViewModel) -> UIViewController {
        return ItemListViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      collectionViewCellFactory: container.views.collectionCells)
    }

    func itemDetail(viewModel: ItemDetailViewModel) -> UIViewController {
        return ItemDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
                                        viewModel: viewModel,
                                        collectionViewCellFactory: container.views.collectionCells)
    }

    func person(viewModel: PersonViewModel) -> UIViewController {
        return ItemDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
                                        viewModel: viewModel,
                                        collectionViewCellFactory: container.views.collectionCells)
    }

    func search(viewModel: SearchViewModel) -> UIViewController {
        return SearchViewController(nibName: name(from: viewModel.layoutIdentifier),
                                    viewModel: viewModel,
                                    collectionViewCellFactory: container.views.collectionCells)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
