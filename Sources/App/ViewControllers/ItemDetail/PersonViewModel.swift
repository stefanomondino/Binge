//
//  PersonUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class PersonViewModel: ItemDetailViewModel {
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

    private let useCase: PersonDetailUseCase

    let person: Person

    let title: String

    init(person: Person,
         itemViewModelFactory: ItemViewModelFactory,
         useCase: PersonDetailUseCase,
         routeFactory: RouteFactory) {
        self.useCase = useCase
        self.person = person
        self.routeFactory = routeFactory
        title = person.title
        self.itemViewModelFactory = itemViewModelFactory
    }

    func reload() {
        disposeBag = DisposeBag()
        useCase.personDetail(for: person)
            .map { [weak self] in self?.map($0) ?? [] }
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    private func map(_ person: PersonInfo) -> [Section] {
//            let routes = self.routes
//            let routeFactory = self.routeFactory
        var topSection = Section(id: UUID().stringValue,
                                 items: [itemViewModelFactory.item(self.person, layout: .title),
                                         itemViewModelFactory.personDescription(person)])

        if let image = person.images?.profiles?.first {
            let supplementary = itemViewModelFactory.image(image, fanart: nil)
            topSection.supplementary.set(supplementary, withKind: ViewIdentifier.Supplementary.parallax.identifierString, atIndex: 0)
        }

//            if let navbar = [Fanart.Format.hdtvLogo]
//                .compactMap({ fanart.showImage(for: $0) })
//                .first?
//                .map({ itemViewModelFactory.fanart($0) }) {
//                navbarTitleViewModelRelay.accept(navbar)
//            }

        var carousels: [ViewModel] = []
        carousels += [
            itemViewModelFactory.castShowsCarousel(for: self.person) { [weak self] in
                self?.navigate(to: $0)
            },
            itemViewModelFactory.castMoviesCarousel(for: self.person) { [weak self] in
                self?.navigate(to: $0)
            }
        ]
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
