//
//  LoginUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class LoginViewModel: RxNavigationViewModel, WithPage {
    let uniqueIdentifier: UniqueIdentifier = UUID()
    var routes: PublishRelay<Route> = PublishRelay()

    var disposeBag: DisposeBag = DisposeBag()
    var pageTitle: String = "Login"

    var pageIcon: UIImage? = Asset.user.image
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.login

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: LoginUseCase
    let routeFactory: RouteFactory

    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: LoginUseCase,
         routeFactory: RouteFactory) {
        self.useCase = useCase
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
    }

    func openLogin() {
        disposeBag = DisposeBag()
        let routeFactory = self.routeFactory
        if let url = useCase.webViewURL() {
            useCase.login()
                .map { routeFactory.restart() }
                .startWith(routeFactory.url(for: url))
                .bind(to: routes)
                .disposed(by: disposeBag)
        }
    }
}

class ListItemViewModel: ViewModel, CustomStringConvertible, Hashable {
    var uniqueIdentifier: UniqueIdentifier

    static func == (lhs: ListItemViewModel, rhs: ListItemViewModel) -> Bool {
        lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    var layoutIdentifier: LayoutIdentifier = ViewIdentifier.header
    var description: String
    init(title: String, identifier: UniqueIdentifier = UUID()) {
        description = title
        uniqueIdentifier = identifier
    }
}
