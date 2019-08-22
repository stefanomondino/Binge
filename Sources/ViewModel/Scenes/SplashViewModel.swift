//
//  SplashViewModel.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxSwift
import Model

public class SplashViewModel: SceneViewModelType, InteractionViewModelType {
    public lazy var selection: Selection = self.defaultSelection()
    
    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.splash
    public init() {
        
    }
    public func start() {
        self.interact(.start)
    }
    public func handleStart() -> Observable<Interaction> {
//        return .deferred {
//            return Observable<Interaction>
//                .just(.route(RestartRoute(viewModel: TestViewModel())))
//                .delaySubscription(2, scheduler: MainScheduler.instance)
//        }
        return UseCases.splash.start().debug().map { _ in
            .route(RestartRoute(viewModel: ShowPagesViewModel()))
        }
    }
}
