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

    private let navbarTitleViewModelRelay: BehaviorRelay<ViewModel?> = BehaviorRelay(value: nil)
    var navbarTitleViewModel: Observable<ViewModel?> { navbarTitleViewModelRelay.asObservable() }

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
        Observable.combineLatest(useCase.seasonDetail(for: season, of: show),
                                 useCase
                                     .fanart(for: show.item)
                                     .map { $0 }
                                     .catchErrorJustReturn(nil))
            .map { [weak self] in self?.map($0.0, fanart: $0.1) ?? [] }
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    private func map(_ season: Season.Info, fanart: FanartResponse?) -> [Section] {
//            let routes = self.routes
//            let routeFactory = self.routeFactory
        let itemViewModelFactory = self.itemViewModelFactory
        var topSection = Section(id: UUID().stringValue,
                                 items: [itemViewModelFactory.item(season, layout: .title),
                                         itemViewModelFactory.seasonDescription(season)])
        if let fanart = [Fanart.Format.seasonThumb("\(season.seasonNumber)")]
            .compactMap({ fanart?.showImage(for: $0) })
            .first?
            .map({ itemViewModelFactory.image($0) }) {
            topSection.supplementary.set(fanart, withKind: ViewIdentifier.Supplementary.parallax.identifierString, atIndex: 0)
        }
        if let navbar = [Fanart.Format.hdtvLogo]
            .compactMap({ fanart?.showImage(for: $0) })
            .first?
            .map({ itemViewModelFactory.image($0) }) {
            navbarTitleViewModelRelay.accept(navbar)
        }
        var sections = [topSection]
        if let episodes = season.episodes {
            let items = episodes.map { itemViewModelFactory.item($0, layout: .episode) }
            sections += [Section(id: "episodes", items: items)]
        }
//        var carousels: [ViewModel] = []
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
        return sections
    }

    func selectItem(at _: IndexPath) {}
}
