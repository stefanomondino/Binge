//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

protocol ItemViewModelFactory {
    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel

    func show(_ show: WithShow, layout: ShowIdentifier) -> ViewModel
    func seasonsCarousel(for show: WithShow, onSelection: @escaping (SeasonInfo) -> Void) -> ViewModel
    func castCarousel(for show: WithShow, onSelection: @escaping (Person) -> Void) -> ViewModel
    func relatedShowsCarousel(for show: WithShow, onSelection: @escaping (Show) -> Void) -> ViewModel
    func person(_ person: Person) -> ViewModel
    func castMember(_ castMember: CastMember) -> ViewModel
    func showDescription(_ show: ShowDetail) -> ViewModel
    func fanart(_ fanart: Fanart) -> ViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: RootContainer

    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel {
        LoadMoreItemViewModel(closure)
    }

    func show(_ show: WithShow, layout: ShowIdentifier) -> ViewModel {
        ShowItemViewModel(show: show.show,
                          layoutIdentifier: layout,
                          imageUseCase: container.model.useCases.images)
    }

    func castCarousel(for show: WithShow, onSelection: @escaping (Person) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.detail
            .cast(for: show.show)
            .map { $0.map { self.castMember($0) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .cast) { itemViewModel in
            if let person = (itemViewModel as? PersonItemViewModel)?.person {
                onSelection(person)
            }
        }
    }

    func seasonsCarousel(for show: WithShow, onSelection: @escaping (SeasonInfo) -> Void) -> ViewModel {
        let observable = container.model
            .useCases
            .shows
            .detail
            .showDetail(for: show.show)
            .map { $0.info?.seasons ?? [] }
            .map { [Section(id: UUID().uuidString, items: $0.map { self.season($0) })] }

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .seasons) { itemViewModel in
            if let season = (itemViewModel as? SeasonItemViewModel)?.season {
                onSelection(season)
            }
        }
    }

    func relatedShowsCarousel(for show: WithShow, onSelection: @escaping (Show) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.detail
            .related(for: show.show)
            .map { $0.map { self.show($0, layout: .posterOnly) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .relatedShows) { itemViewModel in
            if let show = (itemViewModel as? ShowItemViewModel)?.show {
                onSelection(show.show)
            }
        }
    }

    func person(_ person: Person) -> ViewModel {
        PersonItemViewModel(person: person,
                            layoutIdentifier: ViewIdentifier.person,
                            imagesUseCase: container.model.useCases.images)
    }

    func season(_ season: SeasonInfo) -> ViewModel {
        SeasonItemViewModel(season: season,
                            layoutIdentifier: ViewIdentifier.season,
                            imagesUseCase: container.model.useCases.images)
    }

    func castMember(_ castMember: CastMember) -> ViewModel {
        PersonItemViewModel(castMember: castMember,
                            layoutIdentifier: ViewIdentifier.person,
                            imagesUseCase: container.model.useCases.images)
    }

    func fanart(_ fanart: Fanart) -> ViewModel {
        FanartItemViewModel(fanart: fanart,
                            layoutIdentifier: ViewIdentifier.fanart,
                            styleFactory: container.styleFactory)
    }

    func showDescription(_ show: ShowDetail) -> ViewModel {
        DescriptionItemViewModel(description: show.overview)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
