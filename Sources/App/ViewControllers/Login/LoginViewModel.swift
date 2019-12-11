//
//  LoginUseCaseViewModel.swift
//  App
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class LoginViewModel: RxNavigationViewModel {
    var routes: PublishRelay<Route> = PublishRelay()
    
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.login
    
    let itemViewModelFactory: ItemViewModelFactory
    
    private let useCase: LoginUseCase
    let routeFactory: RouteFactory
    let styleFactory: StyleFactory
    
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: LoginUseCase,
         routeFactory: RouteFactory,
         styleFactory: StyleFactory) {
        self.useCase = useCase
        self.styleFactory = styleFactory
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    
    func openLogin() {
        disposeBag = DisposeBag()
        let routeFactory = self.routeFactory
        if let url = useCase.webViewURL() {
            useCase.login()
                .map { routeFactory.restartRoute() }
                .startWith(routeFactory.urlRoute(for: url))
                .bind(to: routes)
                .disposed(by: disposeBag)
           
            
        }
    }
}
