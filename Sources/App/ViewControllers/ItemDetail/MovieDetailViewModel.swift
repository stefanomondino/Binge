//
//  MovieDetailViewModel.swift
//  Binge
//
//  Created by Stefano Mondino on 17/08/2020.
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class MovieDetailViewModel: RxListViewModel, ItemDetailViewModel {
    let uniqueIdentifier: UniqueIdentifier = UUID()

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    let routes: PublishRelay<Route> = PublishRelay()

    private(set) var disposeBag: DisposeBag = DisposeBag()

    let layoutIdentifier: LayoutIdentifier

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: MovieDetailUseCase

    private let movie: ItemContainer

    private let routeFactory: RouteFactory

    private let navbarTitleViewModelRelay: BehaviorRelay<ViewModel?> = BehaviorRelay(value: nil)
    var navbarTitleViewModel: Observable<ViewModel?> { navbarTitleViewModelRelay.asObservable() }
    let backgroundImage: ObservableImage

    init(
        movie: ItemContainer,
        routeFactory: RouteFactory,
        itemViewModelFactory: ItemViewModelFactory,
        useCase: MovieDetailUseCase,
        layout: SceneIdentifier = .itemDetail
    ) {
        self.movie = movie
        self.routeFactory = routeFactory
        self.useCase = useCase
        layoutIdentifier = layout
        self.itemViewModelFactory = itemViewModelFactory
        backgroundImage = useCase
            .fanart(for: movie.item)
            .flatMap { $0.movieImage(for: .background)?.getImage() ?? .empty() }
    }

    func reload() {
        disposeBag = DisposeBag()
        Observable.combineLatest(useCase.movieDetail(for: movie.item), useCase.fanart(for: movie.item))
            .map { [weak self] in self?.map($0.0, fanart: $0.1) ?? [] }
            .debug()
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func selectItem(at _: IndexPath) {}

    func addToFavorite() {}

    private func map(_ show: MovieDetail, fanart: FanartResponse) -> [Section] {
        let routes = self.routes
        let routeFactory = self.routeFactory
        var topSection = Section(id: UUID().stringValue,
                                 items: [itemViewModelFactory.item(show, layout: .title),
                                         itemViewModelFactory.showDescription(show)])
        if let fanart = [Fanart.Format.background]
            .compactMap({ fanart.movieImage(for: $0) })
            .first?
            .map({ itemViewModelFactory.fanart($0) }) {
            topSection.supplementary.set(fanart, withKind: ViewIdentifier.Supplementary.parallax.identifierString, atIndex: 0)
        }
        if let navbar = [Fanart.Format.hdtvLogo]
            .compactMap({ fanart.movieImage(for: $0) })
            .first?
            .map({ itemViewModelFactory.fanart($0) }) {
            navbarTitleViewModelRelay.accept(navbar)
        }
        var carousels: [ViewModel] = []

        carousels += [
            itemViewModelFactory.castCarousel(for: show) {
                routes.accept(routeFactory.personDetail(for: $0))
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
