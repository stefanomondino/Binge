//
//  ShowDetailUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class ShowDetailViewModel: RxListViewModel, RxNavigationViewModel {
    let uniqueIdentifier: UniqueIdentifier = UUID()

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    let routes: PublishRelay<Route> = PublishRelay()

    private(set) var disposeBag: DisposeBag = DisposeBag()

    let layoutIdentifier: LayoutIdentifier

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCase

    private let show: WithShow

    private let routeFactory: RouteFactory

    let backgroundImage: ObservableImage

    init(
        show: WithShow,
        routeFactory: RouteFactory,
        itemViewModelFactory: ItemViewModelFactory,
        useCase: ShowDetailUseCase,
        layout: SceneIdentifier = .showDetail
    ) {
        self.show = show
        self.routeFactory = routeFactory
        self.useCase = useCase
        layoutIdentifier = layout
        self.itemViewModelFactory = itemViewModelFactory
        backgroundImage = useCase
            .fanart(for: show.show)
            .flatMap { $0.image(for: .background)?.getImage() ?? .empty() }
    }

    func reload() {
        disposeBag = DisposeBag()
        Observable.combineLatest(useCase.showDetail(for: show.show), useCase.fanart(for: show.show))
            .map { [weak self] in self?.map($0.0, fanart: $0.1) ?? [] }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func selectItem(at _: IndexPath) {}

    func addToFavorite() {}

    private func map(_ show: ShowDetail, fanart: FanartResponse) -> [Section] {
        let routes = self.routes
        let routeFactory = self.routeFactory
        var topSection = Section(id: UUID().stringValue,
                                 items: [itemViewModelFactory.show(show, layout: .posterOnly)])
        if let fanart = [Fanart.Format.background]
            .compactMap({ fanart.image(for: $0) })
            .first?
            .map({ itemViewModelFactory.fanart($0) }) {
            topSection.supplementary.set(fanart, withKind: "parallax", atIndex: 0)
        }
        return [
            topSection,
            Section(id: "misc", items: [
                itemViewModelFactory.castCarousel(for: show) {
                    routes.accept(routeFactory.personDetail(for: $0))
                },
                itemViewModelFactory.relatedShowsCarousel(for: show) {
                    routes.accept(routeFactory.showDetail(for: $0))
                }
            ])
        ]
    }
}
