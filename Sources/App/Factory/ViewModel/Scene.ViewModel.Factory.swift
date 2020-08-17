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
    func login() -> LoginViewModel
    func itemDetail(for item: ItemContainer) -> ItemDetailViewModel?
    func personDetail(for person: Person) -> PersonViewModel
    func showsPager() -> PagerViewModel
    func seasonDetail(for season: Season.Info, of show: ShowItem) -> ItemDetailViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    let container: RootContainer

    func homePager() -> PagerViewModel {
        return PagerViewModel(pages: [
            showsPager(),
            moviesPager(),
            login()
        ],
        layout: SceneIdentifier.tab,
        styleFactory: container.styleFactory)
    }

    func splashViewModel() -> SplashViewModel {
        return SplashViewModel(routeFactory: container.routeFactory, useCase: container.model.useCases.splash)
    }

    func login() -> LoginViewModel {
        return LoginViewModel(itemFactory: container.viewModels.pickers,
                              routeFactory: container.routeFactory,
                              styleFactory: container.styleFactory)
    }

    func showsPager() -> PagerViewModel {
        return PagerViewModel(pages: [
            popularShows(),
            trendingShows(),
            watchedShows(),
            collectedShows(),
            anticipatedShows()

        ], styleFactory: container.styleFactory)
            .with(\.pageTitle, to: Strings.Shows.shows.translation)
    }

    func moviesPager() -> PagerViewModel {
        return PagerViewModel(pages: [
            popularMovies(),
            trendingMovies(),
            watchedMovies(),
            collectedMovies(),
            anticipatedShows()

        ], styleFactory: container.styleFactory)
            .with(\.pageTitle, to: Strings.Movies.movies.translation)
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

    func itemDetail(for item: ItemContainer) -> ItemDetailViewModel? {
        switch item {
        case let show as ShowItem: return showDetail(for: show)
        case let movie as MovieItem: return movieDetail(for: movie)
        default: return nil
        }
    }

    func showDetail(for show: ShowItem) -> ItemDetailViewModel {
        ShowDetailViewModel(show: show,
                            routeFactory: container.routeFactory,
                            itemViewModelFactory: container.viewModels.items,
                            useCase: container.model.useCases.shows.detail)
    }

    func seasonDetail(for season: Season.Info, of show: ShowItem) -> ItemDetailViewModel {
        SeasonDetailViewModel(season: season,
                              show: show,
                              itemViewModelFactory: container.viewModels.items,
                              useCase: container.model.useCases.shows.detail,
                              routeFactory: container.routeFactory)
    }

    func movieDetail(for movie: MovieItem) -> ItemDetailViewModel {
        MovieDetailViewModel(movie: movie,
                             routeFactory: container.routeFactory,
                             itemViewModelFactory: container.viewModels.items,
                             useCase: container.model.useCases.movies.detail)
    }

    func personDetail(for person: Person) -> PersonViewModel {
        PersonViewModel(person: person,
                        itemViewModelFactory: container.viewModels.items,
                        useCase: container.model.useCases.shows.person,
                        routeFactory: container.routeFactory)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
