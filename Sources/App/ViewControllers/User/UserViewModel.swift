//
//  LoginUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class UserViewModel: RxListViewModel, RxNavigationViewModel, WithPage {
    let uniqueIdentifier: UniqueIdentifier = UUID()
    var routes: PublishRelay<Route> = PublishRelay()

    var disposeBag: DisposeBag = DisposeBag()
    var pageTitle: String = Strings.Profile.title.translation

    var pageIcon: UIImage? = Asset.user.image
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.user
    var isLoginHidden: Observable<Bool> {
        useCase.isLogged()
    }

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ProfileUseCase
    let routeFactory: RouteFactory
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: ProfileUseCase,
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

    func openSettings() {
        let route = routeFactory.settings()
        routes.accept(route)
    }

    private var reloadDisposeBag = DisposeBag()

    func reload() {
        reloadDisposeBag = DisposeBag()
        let items = itemViewModelFactory
        let useCase = self.useCase
        useCase.isLogged().flatMapLatest { isLogged -> Observable<[Section]> in
            if !isLogged { return .just([]) }
            return useCase.user()
                .map { user in
                    [items.image(user.profileURL ?? Asset.user.image, ratio: 1),
                     items.profileHeader(profile: user),
                     items.titledDescription(title: "Name", description: user.name),
                     items.titledDescription(title: "Location", description: user.location)]
                        .compactMap { $0 }
                }
                .map { [Section(items: $0)] }
        }
        .catchErrorJustReturn([])
        .bind(to: sectionsRelay)
        .disposed(by: reloadDisposeBag)
    }

    func selectItem(at _: IndexPath) {}
}
