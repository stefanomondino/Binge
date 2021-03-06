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
protocol SceneViewModelFactory {
    //    func schedule() -> ListViewModel & NavigationViewModel
    //    func showDetail(show: Show) -> ShowDetailViewModel
    func splashViewModel() -> SplashViewModel
    func homePager() -> PagerViewModel
    func user() -> UserViewModel
    func itemDetail(for item: TraktItemContainer) -> ItemDetailViewModel?
    func personDetail(for person: Trakt.Person) -> PersonViewModel
    func showsPager() -> PagerViewModel
    func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> ItemDetailViewModel
    func search() -> SearchViewModel
    func settings() -> SettingsViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    let container: RootContainer

    func homePager() -> PagerViewModel {
        return PagerViewModel(pages: [
            watchablePager(),
            user()
        ],
        layout: SceneIdentifier.tab,
        routeFactory: container.routeFactory,
        isSearchable: false)
    }

    func watchablePager() -> PagerViewModel {
        return PagerViewModel(pages: [
            showsPager(),
            moviesPager(),
            search()
        ],
        layout: SceneIdentifier.bigPager,
        routeFactory: container.routeFactory,
        isSearchable: false)
            .with(\.pageIcon, to: Asset.search.image)
            .with(\.pageTitle, to: Strings.Generic.explore.description)
    }

    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.useCases.splash)
    }

    func user() -> UserViewModel {
        UserViewModel(itemViewModelFactory: container.viewModels.items,
                      useCase: container.model.useCases.profile,
                      routeFactory: container.routeFactory)
    }

    func search() -> SearchViewModel {
        SearchViewModel(itemViewModelFactory: container.viewModels.items,
                        useCase: container.model.useCases.search,
                        routeFactory: container.routeFactory,
                        layout: SceneIdentifier.search)
    }

    func showsPager() -> PagerViewModel {
        return PagerViewModel(pages: [
            popularShows(),
            trendingShows(),
            watchedShows(),
            collectedShows(),
            anticipatedShows()
        ], layout: .smallPager,
        routeFactory: container.routeFactory,
        isSearchable: true)
            .with(\.pageTitle, to: Strings.Shows.title.translation)
            .with(\.pageIcon, to: Asset.photo.image)
    }

    func moviesPager() -> PagerViewModel {
        return PagerViewModel(pages: [
            popularMovies(),
            trendingMovies(),
            watchedMovies(),
            collectedMovies(),
            anticipatedShows()

        ], layout: .smallPager, routeFactory: container.routeFactory,
        isSearchable: true)
            .with(\.pageTitle, to: Strings.Movies.title.translation)
            .with(\.pageIcon, to: Asset.movie.image)
    }

    func popularShows() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.popular,
                          routeFactory: container.routeFactory)
    }

    func trendingShows() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.trending,
                          routeFactory: container.routeFactory)
    }

    func collectedShows() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.collected,
                          routeFactory: container.routeFactory)
    }

    func anticipatedShows() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.anticipated,
                          routeFactory: container.routeFactory)
    }

    func watchedShows() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.watched,
                          routeFactory: container.routeFactory)
    }

    func popularMovies() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.movies.popular,
                          routeFactory: container.routeFactory)
    }

    func trendingMovies() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.movies.trending,
                          routeFactory: container.routeFactory)
    }

    func collectedMovies() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.movies.collected,
                          routeFactory: container.routeFactory)
    }

    func anticipatedMovies() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.movies.anticipated,
                          routeFactory: container.routeFactory)
    }

    func watchedMovies() -> ItemListViewModel {
        ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.movies.watched,
                          routeFactory: container.routeFactory)
    }

    func itemDetail(for item: TraktItemContainer) -> ItemDetailViewModel? {
        switch item {
        case let show as TraktShowItem: return showDetail(for: show)
        case let movie as TraktMovieItem: return movieDetail(for: movie)
        default: return nil
        }
    }

    func showDetail(for show: TraktShowItem) -> ItemDetailViewModel {
        ShowDetailViewModel(show: show,
                            routeFactory: container.routeFactory,
                            itemViewModelFactory: container.viewModels.items,
                            useCase: container.model.useCases.shows.detail)
    }

    func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> ItemDetailViewModel {
        SeasonDetailViewModel(season: season,
                              show: show,
                              itemViewModelFactory: container.viewModels.items,
                              useCase: container.model.useCases.shows.detail,
                              routeFactory: container.routeFactory)
    }

    func movieDetail(for movie: TraktMovieItem) -> ItemDetailViewModel {
        MovieDetailViewModel(movie: movie,
                             routeFactory: container.routeFactory,
                             itemViewModelFactory: container.viewModels.items,
                             useCase: container.model.useCases.movies.detail)
    }

    func personDetail(for person: Trakt.Person) -> PersonViewModel {
        PersonViewModel(person: person,
                        itemViewModelFactory: container.viewModels.items,
                        useCase: container.model.useCases.shows.person,
                        routeFactory: container.routeFactory)
    }

    func settings() -> SettingsViewModel {
        SettingsViewModel(pickers: container.viewModels.pickers, routeFactory: container.routeFactory)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
