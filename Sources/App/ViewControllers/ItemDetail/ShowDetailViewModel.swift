//
//  ShowDetailUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class ShowDetailViewModel: ItemDetailViewModel {
    let uniqueIdentifier: UniqueIdentifier = UUID()

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    let routes: PublishRelay<Route> = PublishRelay()

    private(set) var disposeBag: DisposeBag = DisposeBag()

    let layoutIdentifier: LayoutIdentifier

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCase

    private let show: ItemContainer

    let routeFactory: RouteFactory

    private let navbarTitleViewModelRelay: BehaviorRelay<ViewModel?> = BehaviorRelay(value: nil)
    var navbarTitleViewModel: Observable<ViewModel?> { navbarTitleViewModelRelay.asObservable() }
    let backgroundImage: ObservableImage

    let title: String

    init(
        show: ItemContainer,
        routeFactory: RouteFactory,
        itemViewModelFactory: ItemViewModelFactory,
        useCase: ShowDetailUseCase,
        layout: SceneIdentifier = .itemDetail
    ) {
        self.show = show
        title = show.item.title
        self.routeFactory = routeFactory
        self.useCase = useCase
        layoutIdentifier = layout
        self.itemViewModelFactory = itemViewModelFactory
        backgroundImage = useCase
            .fanart(for: show.item)
            .flatMap { $0.showImage(for: .background)?.getImage() ?? .empty() }
    }

    func reload() {
        disposeBag = DisposeBag()
        Observable.combineLatest(useCase.showDetail(for: show.item),
                                 useCase
                                     .fanart(for: show.item)
                                     .map { $0 }
                                     .catchErrorJustReturn(nil))
            .map { [weak self] in self?.map($0.0, fanart: $0.1) ?? [] }
            .catchErrorJustReturn([])
            .takeLast(1)
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func selectItem(at _: IndexPath) {}

    func addToFavorite() {}

    private func map(_ show: ShowDetail, fanart: FanartResponse?) -> [Section] {
        let routes = self.routes
        let routeFactory = self.routeFactory
        let backdrop = itemViewModelFactory.image(show, fanart: fanart?.showImage(for: .background))

        let topSection = Section(items: [itemViewModelFactory.item(show, layout: .title),
                                         itemViewModelFactory.titledDescription(title: Strings.Generic.year, description: show.year?.stringValue),
                                         itemViewModelFactory.titledDescription(title: Strings.Shows.popular, description: show.info?.popularity),
                                         itemViewModelFactory.titledDescription(title: Strings.Shows.status, description: show.info?.status),
                                         itemViewModelFactory.titledDescription(title: Strings.Shows.genres,
                                                                                description:
                                                                                show.info?.genres?.compactMap { $0.name }.joined(separator: ", ")),
                                         itemViewModelFactory.titledDescription(title: Strings.Shows.network,
                                                                                description:
                                                                                show.info?.networks?.compactMap { $0.name }.joined(separator: ", ")),
                                         itemViewModelFactory.showDescription(show)]
                .compactMap { $0 },
            supplementary: .init(items: [0: [ViewIdentifier.Supplementary.parallax.identifierString: backdrop]]))

        if let navbar = [Fanart.Format.hdtvLogo]
            .compactMap({ fanart?.showImage(for: $0) })
            .first?
            .map({ itemViewModelFactory.image(show, fanart: $0) }) {
            navbarTitleViewModelRelay.accept(navbar)
        }
        var carousels: [ViewModel] = []
        if show.info?.seasons != nil {
            carousels += [itemViewModelFactory.seasonsCarousel(for: show, onSelection: { season in
                routes.accept(routeFactory.seasonDetail(for: season, of: show))
            })]
        }
        carousels += [
            itemViewModelFactory.castCarousel(for: show) { [weak self] in
                self?.navigate(to: $0)
                //                routes.accept(routeFactory.personDetail(for: $0))
            },
            itemViewModelFactory.relatedCarousel(for: show) {
                routes.accept(routeFactory.showDetail(for: $0))
            }
        ].compactMap { $0 }

        return [
            topSection,
            Section(id: UUID().stringValue, items: carousels)
        ]
    }
}
