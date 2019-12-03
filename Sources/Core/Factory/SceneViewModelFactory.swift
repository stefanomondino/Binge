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

enum CoreSceneIdentifier: String, LayoutIdentifier {

    case splash
    
    var identifierString: String {
        return self.rawValue
    }
}

public protocol SceneViewModelFactory {
    //    func schedule() -> ListViewModel & NavigationViewModel
    //    func showDetail(show: Show) -> ShowDetailViewModel
    func splashViewModel() -> SplashViewModel
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    
    let container: CoreDependencyContainer
    
    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.useCases.splash)
    }
}
