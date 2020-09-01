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

protocol StringViewModel: ViewModel, CustomStringConvertible {}

protocol ItemViewModelFactory {
    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel

    func seasonsCarousel(for show: TraktItemContainer, onSelection: @escaping (TMDB.Season.Info) -> Void) -> ViewModel
    func castCarousel(for item: TraktItemContainer, onSelection: @escaping (Trakt.Person) -> Void) -> ViewModel?
    func relatedCarousel(for show: TraktItemContainer, onSelection: @escaping (TraktItem) -> Void) -> ViewModel?
    func person(_ person: Trakt.Person) -> ViewModel
    func personDescription(_ person: TMDB.Person.Info) -> ViewModel
    func castMember(_ castMember: Trakt.CastMember) -> ViewModel
    func showDescription(_ show: TraktItemDetail) -> ViewModel
    func movieDescription(_ show: TraktItemDetail) -> ViewModel
    func seasonDescription(_ season: TMDB.Season.Info) -> ViewModel
    //    func image(_ fanart: Fanart) -> ViewModel
    func image(_: DownloadableImage, fanart: Fanart?) -> ViewModel
    func image(_ image: WithImage, ratio: CGFloat) -> ViewModel
    func castMoviesCarousel(for person: Trakt.Person, onSelection: @escaping (TraktItem) -> Void) -> ViewModel
    func castShowsCarousel(for person: Trakt.Person, onSelection: @escaping (TraktItem) -> Void) -> ViewModel
    func titledDescription(title: CustomStringConvertible, description: CustomStringConvertible?) -> ViewModel?
    func settingsValue(title: CustomStringConvertible, identifier: UniqueIdentifier) -> DescriptionItemViewModel
    func userShowsHistoryCarousel(onSelection: @escaping (TraktItem) -> Void) -> ViewModel
    func profileHeader(profile: User) -> ViewModel
    func button(with contents: ButtonContents) -> ViewModel

    func item(_ item: GenericItem, layout: GenericItemViewModel.Identifier) -> ViewModel

    //    func item(_ item: GenericItem, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: TraktItemContainer, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: Trakt.Show.Cast, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: Trakt.Movie.Cast, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: TMDB.Season.Info, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: TMDB.Season.Episode, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: Trakt.Search.SearchItem, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: Trakt.Person, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: Trakt.CastMember, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: TraktShowItem, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: TraktMovieItem, layout: GenericItemViewModel.Identifier) -> ViewModel
//    func item(_ item: Trakt.UserWatched, layout: GenericItemViewModel.Identifier) -> ViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: RootContainer

    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel {
        LoadMoreItemViewModel(closure)
    }

    func item(_ item: Trakt.Show.Cast, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: Trakt.Movie.Cast, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: TMDB.Season.Info, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: TMDB.Season.Episode, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: Trakt.Search.SearchItem, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: Trakt.Person, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: Trakt.CastMember, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: TraktShowItem, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: TraktMovieItem, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: Trakt.UserWatched, layout: GenericItemViewModel.Identifier) -> ViewModel {
        GenericItemViewModel(item,
                             layoutIdentifier: layout,
                             imagesUseCase: container.model.useCases.images)
    }

    func item(_ item: GenericItem, layout: GenericItemViewModel.Identifier) -> ViewModel {
        switch item {
        case let item as Trakt.UserWatched: return self.item(item, layout: layout)
        case let item as TraktShowItem: return self.item(item, layout: layout)
        case let item as TraktMovieItem: return self.item(item, layout: layout)
        case let item as Trakt.Show.Cast: return self.item(item, layout: layout)
        case let item as TMDB.Season.Info: return self.item(item, layout: layout)
        case let item as TMDB.Season.Episode: return self.item(item, layout: layout)

        default: return GenericItemViewModel(item, layoutIdentifier: layout, imagesUseCase: container.model.useCases.images)
        }
    }

    func castCarousel(for item: TraktItemContainer, onSelection: @escaping (Trakt.Person) -> Void) -> ViewModel? {
        switch item {
        case let show as TraktShowItem: return showsCastCarousel(for: show, onSelection: onSelection)
        case let movie as TraktMovieItem: return moviesCastCarousel(for: movie, onSelection: onSelection)
        default: return nil
        }
    }

    func showsCastCarousel(for show: TraktItemContainer, onSelection: @escaping (Trakt.Person) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.detail
            .cast(for: show.item)
            .map { $0.map { self.castMember($0) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .cast) { itemViewModel in
            if let person = itemViewModel.as(GenericItemViewModel.self)?
                .unwrap(\.item, as: Trakt.Person.self) {
                onSelection(person)
            }
        }
    }

    func moviesCastCarousel(for show: TraktItemContainer, onSelection: @escaping (Trakt.Person) -> Void) -> ViewModel {
        let observable = container.model.useCases.movies.detail
            .cast(for: show.item)
            .map { $0.map { self.castMember($0) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .cast) { itemViewModel in
            if let person = itemViewModel.as(GenericItemViewModel.self)?
                .unwrap(\.item, as: Trakt.Person.self) {
                onSelection(person)
            }
        }
    }

    func seasonsCarousel(for show: TraktItemContainer, onSelection: @escaping (TMDB.Season.Info) -> Void) -> ViewModel {
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
            if let season = itemViewModel.as(GenericItemViewModel.self)?.unwrap(\.item, as: TMDB.Season.Info.self) {
                onSelection(season)
            }
        }
    }

    func relatedCarousel(for item: TraktItemContainer, onSelection: @escaping (TraktItem) -> Void) -> ViewModel? {
        switch item {
        case let show as TraktShowItem: return relatedShowsCarousel(for: show, onSelection: onSelection)
        case let movie as TraktMovieItem: return relatedMoviesCarousel(for: movie, onSelection: onSelection)
        default: return nil
        }
    }

    func relatedShowsCarousel(for show: TraktItemContainer, onSelection: @escaping (TraktItem) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.detail
            .related(for: show.item)
            .map { $0.map { self.item($0, layout: .posterOnly) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .relatedShows) { itemViewModel in
            if let show = itemViewModel.as(GenericItemViewModel.self)?.item as? TraktItemContainer {
                onSelection(show.item)
            }
        }
    }

    func userShowsHistoryCarousel(onSelection: @escaping (TraktItem) -> Void) -> ViewModel {
        let observable = container.model.useCases.profile.showsHistory()
            .map { $0.map { self.item($0, layout: .episode) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .episodes) { itemViewModel in
            if let show = itemViewModel.as(GenericItemViewModel.self)?.item as? TraktItemContainer {
                onSelection(show.item)
            }
        }
    }

    func relatedMoviesCarousel(for show: TraktItemContainer, onSelection: @escaping (TraktItem) -> Void) -> ViewModel {
        let observable = container.model.useCases.movies.detail
            .related(for: show.item)
            .map { $0.map { self.item($0, layout: .posterOnly) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .relatedShows) { itemViewModel in
            if let show = itemViewModel.as(GenericItemViewModel.self)?.item as? TraktItemContainer {
                onSelection(show.item)
            }
        }
    }

    func castMoviesCarousel(for person: Trakt.Person, onSelection: @escaping (TraktItem) -> Void) -> ViewModel {
        let observable = container.model.useCases.movies.person
            .cast(for: person)
            .map { $0.map { self.item($0, layout: .full) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .castInMovie) { itemViewModel in
            if let show = itemViewModel.as(GenericItemViewModel.self)?.item as? TraktItemContainer {
                onSelection(show.item)
            }
        }
    }

    func castShowsCarousel(for person: Trakt.Person, onSelection: @escaping (TraktItem) -> Void) -> ViewModel {
        let observable = container.model.useCases.shows.person
            .cast(for: person)
            .map { $0.map { self.item($0, layout: .full) } }
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .share(replay: 1, scope: .forever)

        return CarouselItemViewModel(sections: observable,
                                     layoutIdentifier: ViewIdentifier.carousel,
                                     cellFactory: container.views.collectionCells,
                                     type: .castInShow) { itemViewModel in
            if let show = itemViewModel.as(GenericItemViewModel.self)?.item as? TraktItemContainer {
                onSelection(show.item)
            }
        }
    }

    func person(_ person: Trakt.Person) -> ViewModel {
        item(person, layout: .person)
    }

    func season(_ season: TMDB.Season.Info) -> ViewModel {
        item(season, layout: .season)
    }

    func castMember(_ castMember: Trakt.CastMember) -> ViewModel {
        item(castMember, layout: .person)
    }

    func image(_ fanart: Fanart) -> ViewModel {
        ImageItemViewModel(fanart: fanart,
                           layoutIdentifier: ViewIdentifier.image)
    }

    func image(_ image: WithImage, ratio: CGFloat) -> ViewModel {
        ImageItemViewModel(image: image,
                           layoutIdentifier: ViewIdentifier.image,
                           ratio: ratio)
    }

    func image(_ image: DownloadableImage, fanart: Fanart?) -> ViewModel {
        ImageItemViewModel(image: image,
                           fanart: fanart,
                           useCase: container.model.useCases.images,
                           layoutIdentifier: ViewIdentifier.image)
    }

    func showDescription(_ show: TraktItemDetail) -> ViewModel {
        DescriptionItemViewModel(description: show.overview)
    }

    func movieDescription(_ movie: TraktItemDetail) -> ViewModel {
        DescriptionItemViewModel(description: movie.overview)
    }

    func seasonDescription(_ season: TMDB.Season.Info) -> ViewModel {
        DescriptionItemViewModel(description: season.overview)
    }

    func personDescription(_ person: TMDB.Person.Info) -> ViewModel {
        DescriptionItemViewModel(description: person.biography)
    }

    func titledDescription(title: CustomStringConvertible, description: CustomStringConvertible?) -> ViewModel? {
        guard let description = description else { return nil }
        return DescriptionItemViewModel(description: "\(title.inTag(.bold))  \(description)")
    }

    func settingsValue(title: CustomStringConvertible, identifier: UniqueIdentifier) -> DescriptionItemViewModel {
        return DescriptionItemViewModel(description: title.description, uniqueIdentifier: identifier)
    }

    func profileHeader(profile: User) -> ViewModel {
        ProfileHeaderItemViewModel(profile: profile)
    }

    func button(with contents: ButtonContents) -> ViewModel {
        ButtonItemViewModel(contents: contents)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
