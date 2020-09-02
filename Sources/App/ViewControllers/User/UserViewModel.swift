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
    var isLoading: Observable<Bool> {
        loadingRelay.isLoading
    }

    let loadingRelay = BehaviorRelay<Int>(value: 0)
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

        let useCase = self.useCase
        let loadingCount = loadingRelay
        useCase
            .isLogged()
            .flatMapLatest { isLogged -> Observable<[Section]> in
                if !isLogged { return .just([]) }
                return useCase.user()
                    .flatMapLatest { user in
                        useCase
                            .genresStats()
                            .map { [weak self] genres in
                                self?.mapSections(from: user, genres: genres) ?? []
                            }
                    }

                    .bindingLoadingStatus(to: loadingCount)
            }
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: reloadDisposeBag)
    }

    private func mapSections(from settings: User.Settings, genres: [Trakt.UserGenresStats]) -> [Section] {
        let items = itemViewModelFactory
        let disposeBag = self.disposeBag
        let user = settings.user

        let useCase = self.useCase
        let elements =
            [
                items.profileHeader(profile: user),
                items.titledDescription(title: "Name", description: user.name),
                items.titledDescription(title: "Location", description: user.location),
                items.button(with: ButtonContents(title: "Logout", action: {
                    useCase.logout().subscribe().disposed(by: disposeBag)
                }))
            ]
            .compactMap { $0 }
        var section = Section(items: elements)
        let coverImage: WithImage = settings.coverURL ?? Asset.heart.image
        let cover = items.image(coverImage, ratio: 16 / 9)
        section.supplementary.set(cover, withKind: ViewIdentifier.Supplementary.parallax.identifierString, atIndex: 0)
        return [section,
                Section(items: [items.userShowsHistoryCarousel(onSelection: { print($0) })]),
                Section(items: [items.genresStats(genresStats: genres)])]
    }

    func selectItem(at _: IndexPath) {}
}
