//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang
import Core

enum SceneIdentifier: String, LayoutIdentifier {
    case splash
    case pager
    case showList
    case showDetail
    case login
    
    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}

protocol ViewControllerFactory: CoreSceneFactory {
    func root() -> UIViewController
    func showPager() -> UIViewController
    func showList(viewModel: ShowListViewModel) -> UIViewController
    func login(viewModel: LoginViewModel) -> UIViewController
//    func schedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController
//    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController
}

class DefaultViewControllerFactory: ViewControllerFactory {
    let container: AppDependencyContainer
    
    init(container: AppDependencyContainer) {
        self.container = container
    }
    
    private func name(from layoutIdentifier: LayoutIdentifier) -> String {
        let identifier = layoutIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"
    }
    
//    func schedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController {
//        return ScheduleViewController(nibName: name(from: viewModel.layoutIdentifier),
//                                      viewModel: viewModel,
//                                      collectionViewCellFactory: container.collectionViewCellFactory)
//    }
//
//    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController {
//        return ShowDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
//                                        viewModel: viewModel,
//                                        collectionViewCellFactory: container.collectionViewCellFactory)
//    }
    
    func root() -> UIViewController {
        let viewModel = SplashViewModel(routeFactory: container.core.routeFactory, useCase: container.model.useCases.splash)
        return SplashViewController(viewModel: viewModel)
    }
    func home() -> Scene {
        return showPager()
    }
    func showPager() -> UIViewController {
        let viewModel = container.sceneViewModelFactory.showsPager()
        return PagerViewController(viewModel: viewModel, routeFactory: container.routeFactory, styleFactory: container.styleFactory)
    }
    
    func showList(viewModel: ShowListViewModel) -> UIViewController {
        return ShowListViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      collectionViewCellFactory: container.collectionViewCellFactory)
    }
    func login(viewModel: LoginViewModel) -> UIViewController {
        return LoginViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   viewModel: viewModel,
                                   collectionViewCellFactory: container.collectionViewCellFactory)
    }
}
