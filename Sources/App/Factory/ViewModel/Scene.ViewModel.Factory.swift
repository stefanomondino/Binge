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
    func showDetail(for show: WithShow) -> ShowDetailViewModel
    func personDetail(for person: Person) -> PersonViewModel
    func popularShows() -> ShowListViewModel
    func trendingShows() -> ShowListViewModel
    func watchedShows() -> ShowListViewModel
    func showsPager() -> PagerViewModel
    // MURRAY DECLARATION PLACEHOLDER
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    let container: RootContainer

    func homePager() -> PagerViewModel {
        return PagerViewModel(pages: [
            showsPager(),
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

    func popularShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.popular,
                          routeFactory: container.routeFactory)
    }

    func trendingShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.trending,
                          routeFactory: container.routeFactory)
    }

    func collectedShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.collected,
                          routeFactory: container.routeFactory)
    }

    func anticipatedShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.anticipated,
                          routeFactory: container.routeFactory)
    }

    func watchedShows() -> ShowListViewModel {
        ShowListViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.model.useCases.shows.watched,
                          routeFactory: container.routeFactory)
    }

    func showDetail(for show: WithShow) -> ShowDetailViewModel {
        ShowDetailViewModel(show: show,
                            routeFactory: container.routeFactory,
                            itemViewModelFactory: container.viewModels.items,
                            useCase: container.model.useCases.shows.detail)
    }

    func personDetail(for person: Person) -> PersonViewModel {
        PersonViewModel(person: person,
                        itemViewModelFactory: container.viewModels.items,
                        useCase: container.model.useCases.shows.person,
                        styleFactory: container.styleFactory)
    }

    // MURRAY IMPLEMENTATION PLACEHOLDER
}
