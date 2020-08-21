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

    let routeFactory: RouteFactory

    private let navbarTitleViewModelRelay: BehaviorRelay<ViewModel?> = BehaviorRelay(value: nil)
    var navbarTitleViewModel: Observable<ViewModel?> { navbarTitleViewModelRelay.asObservable() }
    let backgroundImage: ObservableImage

    let title: String

    init(
        movie: ItemContainer,
        routeFactory: RouteFactory,
        itemViewModelFactory: ItemViewModelFactory,
        useCase: MovieDetailUseCase,
        layout: SceneIdentifier = .itemDetail
    ) {
        self.movie = movie
        title = movie.item.title
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
        Observable.combineLatest(useCase.movieDetail(for: movie.item),
                                 useCase.fanart(for: movie.item)
                                     .map { $0 }
                                     .catchErrorJustReturn(nil))
            .map { [weak self] in self?.map($0.0, fanart: $0.1) ?? [] }
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func selectItem(at _: IndexPath) {}

    func addToFavorite() {}

    private func map(_ movie: MovieDetail, fanart: FanartResponse?) -> [Section] {
        let routes = self.routes
        let routeFactory = self.routeFactory
        var topSection = Section(id: UUID().stringValue,
                                 items: [itemViewModelFactory.item(movie, layout: .title),
                                         itemViewModelFactory.showDescription(movie)])
        let backdrop =
            itemViewModelFactory.image(movie, fanart: fanart?.movieImage(for: [.background, .hdtvLogo]))
        topSection.supplementary.set(backdrop, withKind: ViewIdentifier.Supplementary.parallax.identifierString, atIndex: 0)

        if let navbarItem = fanart?.movieImage(for: [Fanart.Format.hdtvLogo]) {
            navbarTitleViewModelRelay.accept(itemViewModelFactory.image(movie, fanart: navbarItem))
        }
        var carousels: [ViewModel] = []

        carousels += [
            itemViewModelFactory.castCarousel(for: movie) {
                routes.accept(routeFactory.personDetail(for: $0))
            },
            itemViewModelFactory.relatedCarousel(for: movie) {
                routes.accept(routeFactory.showDetail(for: $0))
            }
        ].compactMap { $0 }
        return [
            topSection,
            Section(id: UUID().stringValue, items: carousels)
        ]
    }
}
