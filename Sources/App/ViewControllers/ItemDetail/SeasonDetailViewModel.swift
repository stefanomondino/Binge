//
//  PersonUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class SeasonDetailViewModel: ItemDetailViewModel {
    var routeFactory: RouteFactory

    var navbarTitleViewModel: Observable<ViewModel?> = .just(nil)

    var backgroundImage: ObservableImage = .empty()

    func addToFavorite() {}

    let uniqueIdentifier: UniqueIdentifier = UUID()
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    var routes: PublishRelay<Route> = PublishRelay()
    var disposeBag: DisposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.itemDetail

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCase

    let season: Season.Info
    let show: ShowItem
    let title: String

    init(season: Season.Info,
         show: ShowItem,
         itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowDetailUseCase,
         routeFactory: RouteFactory) {
        self.useCase = useCase
        self.season = season
        self.show = show
        self.routeFactory = routeFactory
        title = season.title
        self.itemViewModelFactory = itemViewModelFactory
    }

    func reload() {
        disposeBag = DisposeBag()
        useCase.seasonDetail(for: season, of: show).debug()
            .map { [weak self] in self?.map($0) ?? [] }
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    private func map(_: Season.Info) -> [Section] {
//            let routes = self.routes
//            let routeFactory = self.routeFactory
        var topSection = Section(id: UUID().stringValue,
                                 items: [itemViewModelFactory.item(season, layout: .title),
                                         itemViewModelFactory.seasonDescription(season)])
//
//        if let image = person.images?.profiles?.first {
//            let supplementary = itemViewModelFactory.image(image)
//            topSection.supplementary.set(supplementary, withKind: ViewIdentifier.Supplementary.parallax.identifierString, atIndex: 0)
//        }

//            if let navbar = [Fanart.Format.hdtvLogo]
//                .compactMap({ fanart.showImage(for: $0) })
//                .first?
//                .map({ itemViewModelFactory.fanart($0) }) {
//                navbarTitleViewModelRelay.accept(navbar)
//            }

        var carousels: [ViewModel] = []
//        carousels += [
//            itemViewModelFactory.castShowsCarousel(for: self.person) { [weak self] in
//                self?.navigate(to: $0)
//            },
//            itemViewModelFactory.castMoviesCarousel(for: self.person) { [weak self] in
//                          self?.navigate(to: $0)
//                      }
//        ]
//            var carousels: [ViewModel] = []
//            if show.info?.seasons != nil {
//                carousels += [itemViewModelFactory.seasonsCarousel(for: show, onSelection: { _ in })]
//            }
//            carousels += [
//                itemViewModelFactory.castCarousel(for: show) { [weak self] in
//                    self?.navigate(to: $0)
//    //                routes.accept(routeFactory.personDetail(for: $0))
//                },
//                itemViewModelFactory.relatedCarousel(for: show) {
//                    routes.accept(routeFactory.showDetail(for: $0))
//                }
//            ].compactMap { $0 }
//
        return [
            topSection,
            Section(id: UUID().stringValue, items: carousels)
        ]
    }

    func selectItem(at _: IndexPath) {}
}
