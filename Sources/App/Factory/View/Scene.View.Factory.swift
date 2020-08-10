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

protocol ViewControllerFactory {
    func root() -> UIViewController
    func pager(viewModel: PagerViewModel) -> UIViewController
    func mainTabBar() -> UIViewController
    func login(viewModel: LoginViewModel) -> UIViewController

    // MURRAY DECLARATION PLACEHOLDER
}

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

    func pager(viewModel: PagerViewModel) -> UIViewController {
        return PagerViewController(viewModel: viewModel, routeFactory: container.routeFactory, styleFactory: container.styleFactory)
    }

    func mainTabBar() -> UIViewController {
        let viewModel = container.viewModels.scenes.homePager()
        return TabViewController(viewModel: viewModel, routeFactory: container.routeFactory, styleFactory: container.styleFactory)
    }

    func login(viewModel: LoginViewModel) -> UIViewController {
        return LoginViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   viewModel: viewModel,
                                   collectionViewCellFactory: container.views.collectionCells)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
