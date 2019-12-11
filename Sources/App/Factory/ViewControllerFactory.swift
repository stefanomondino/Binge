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

enum SceneIdentifier: String, LayoutIdentifier {
    case splash
    case pager
    case tab
    case showList
    case showDetail
    case exampleForm
	case login
	//MURRAY ENUM PLACEHOLDER

    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}

protocol ViewControllerFactory {
    func root() -> UIViewController
    func pager(viewModel: PagerViewModel) -> UIViewController
    func showPager() -> UIViewController
    func mainTabBar() -> UIViewController
    func showList(viewModel: ShowListViewModel) -> UIViewController
    func exampleForm(viewModel: ExampleFormViewModel) -> UIViewController
    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController
    func login(viewModel: LoginViewModel) -> UIViewController
    
//MURRAY DECLARATION PLACEHOLDER
    
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
    
    func root() -> UIViewController {
        return SplashViewController(viewModel: container.sceneViewModelFactory.splashViewModel())
    }
    func pager(viewModel: PagerViewModel) -> UIViewController {
         return PagerViewController(viewModel: viewModel, routeFactory: container.routeFactory, styleFactory: container.styleFactory)
    }
    func showPager() -> UIViewController {
    let viewModel = container.sceneViewModelFactory.showsPager()
       return pager(viewModel: viewModel)
    }
    func mainTabBar() -> UIViewController {
        let viewModel = container.sceneViewModelFactory.homePager()
        return TabViewController(viewModel: viewModel, routeFactory: container.routeFactory, styleFactory: container.styleFactory)
    }
    
    func showList(viewModel: ShowListViewModel) -> UIViewController {
        return ShowListViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      collectionViewCellFactory: container.collectionViewCellFactory)
    }
    func exampleForm(viewModel: ExampleFormViewModel) -> UIViewController {
        return ExampleFormViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   viewModel: viewModel,
                                   collectionViewCellFactory: container.collectionViewCellFactory)
    }

    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController {
        return ShowDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   	viewModel: viewModel,
                                   	collectionViewCellFactory: container.collectionViewCellFactory)
    }
    
    func login(viewModel: LoginViewModel) -> UIViewController {
        return LoginViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   	viewModel: viewModel,
                                   	collectionViewCellFactory: container.collectionViewCellFactory)
    }
    
    //MURRAY IMPLEMENTATION PLACEHOLDER
}
