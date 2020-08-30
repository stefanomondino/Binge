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
    func item(_ show: GenericItem, layout: GenericItemViewModel.Identifier) -> ViewModel
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
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: RootContainer

    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel {
        LoadMoreItemViewModel(closure)
    }

    func item(_ item: GenericItem, layout: GenericItemViewModel.Identifier) -> ViewModel {
        switch item {
        case let showCast as Trakt.Show.Cast: return GenericItemViewModel(showCast: showCast,
                                                                          layoutIdentifier: layout,
                                                                          imageUseCase: container.model.useCases.images)
        case let movieCast as Trakt.Movie.Cast: return GenericItemViewModel(movieCast: movieCast,
                                                                            layoutIdentifier: layout,
                                                                            imageUseCase: container.model.useCases.images)
        case let season as TMDB.Season.Info: return GenericItemViewModel(season: season,
                                                                         layoutIdentifier: layout,
                                                                         imagesUseCase: container.model.useCases.images)
        case let search as Trakt.Search.SearchItem: return GenericItemViewModel(search: search,
                                                                                layoutIdentifier: layout,
                                                                                imageUseCase: container.model.useCases.images)

        case let episode as TMDB.Season.Episode: return GenericItemViewModel(episode: episode,
                                                                             layoutIdentifier: layout,
                                                                             imagesUseCase: container.model.useCases.images)

        case let person as Trakt.Person: return GenericItemViewModel(person: person,
                                                                     layoutIdentifier: layout,
                                                                     imagesUseCase: container.model.useCases.images)
        case let person as Trakt.CastMember: return GenericItemViewModel(castMember: person,
                                                                         layoutIdentifier: layout,
                                                                         imagesUseCase: container.model.useCases.images)
        case let show as TraktShowItem: return GenericItemViewModel(show: show,
                                                                    layoutIdentifier: layout,
                                                                    imageUseCase: container.model.useCases.images)
        case let movie as TraktMovieItem: return GenericItemViewModel(movie: movie,
                                                                      layoutIdentifier: layout,
                                                                      imageUseCase: container.model.useCases.images)
        default: return GenericItemViewModel(item: item,
                                             layoutIdentifier: layout,
                                             imageUseCase: container.model.useCases.images)
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
        GenericItemViewModel(person: person,
                             layoutIdentifier: .person,
                             imagesUseCase: container.model.useCases.images)
    }

    func season(_ season: TMDB.Season.Info) -> ViewModel {
        GenericItemViewModel(season: season, layoutIdentifier: .season, imagesUseCase: container.model.useCases.images)
        //        SeasonItemViewModel(season: season,
        //                            layoutIdentifier: ViewIdentifier.season,
        //                            imagesUseCase: container.model.useCases.images)
    }

    func castMember(_ castMember: Trakt.CastMember) -> ViewModel {
        GenericItemViewModel(castMember: castMember, layoutIdentifier: .person, imagesUseCase: container.model.useCases.images)
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
