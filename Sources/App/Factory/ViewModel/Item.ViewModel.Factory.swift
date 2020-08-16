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
    func item(_ show: ItemContainer, layout: ShowIdentifier) -> ViewModel
    func seasonsCarousel(for show: ItemContainer, onSelection: @escaping (Season.Info) -> Void) -> ViewModel
    func castCarousel(for show: ItemContainer, onSelection: @escaping (Person) -> Void) -> ViewModel
    func relatedShowsCarousel(for show: ItemContainer, onSelection: @escaping (Item) -> Void) -> ViewModel
    func person(_ person: Person) -> ViewModel
    func castMember(_ castMember: CastMember) -> ViewModel
    func showDescription(_ show: ItemDetail) -> ViewModel
    func fanart(_ fanart: Fanart) -> ViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: RootContainer

    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel {
        LoadMoreItemViewModel(closure)
    }

    func item(_ item: ItemContainer, layout: ShowIdentifier) -> ViewModel {
        switch item {
        case let show as ShowItem: return ShowItemViewModel(show: show,
                                                            layoutIdentifier: layout,
                                                            imageUseCase: container.model.useCases.images)
        case let movie as MovieItem: return ShowItemViewModel(movie: movie,
                                                              layoutIdentifier: layout,
                                                              imageUseCase: container.model.useCases.images)
        default: return ShowItemViewModel(item: item.item,
                                          layoutIdentifier: layout,
                                          imageUseCase: container.model.useCases.images)
        }
    }

    func castCarousel(for show: ItemContainer, onSelection: @escaping (Person) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.detail
            .cast(for: show.item)
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

    func seasonsCarousel(for show: ItemContainer, onSelection: @escaping (Season.Info) -> Void) -> ViewModel {
        let observable = container.model
            .useCases
            .shows
            .detail
            .showDetail(for: show.item)
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

    func relatedShowsCarousel(for show: ItemContainer, onSelection: @escaping (Item) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.detail
            .related(for: show.item)
            .map { $0.map { self.item($0, layout: .posterOnly) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .relatedShows) { itemViewModel in
            if let show = (itemViewModel as? ShowItemViewModel)?.item {
                onSelection(show.item)
            }
        }
    }

    func person(_ person: Person) -> ViewModel {
        PersonItemViewModel(person: person,
                            layoutIdentifier: ViewIdentifier.person,
                            imagesUseCase: container.model.useCases.images)
    }

    func season(_ season: Season.Info) -> ViewModel {
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

    func showDescription(_ show: ItemDetail) -> ViewModel {
        DescriptionItemViewModel(description: show.overview)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
