//
//  UseCases.swift
//  Model
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

public protocol UseCaseContainer {
    var splash: SplashUseCase { get }
    var login: LoginUseCase { get }
    var shows: ShowsContainer { get }
    var movies: MoviesContainer { get }
    var images: ImagesUseCase { get }
    var search: SearchUseCase { get }
    var themes: ThemeUseCase { get }
    // MURRAY PROTOCOL
}

enum UseCaseKeys: CaseIterable, Hashable {
    case splash
    case login
    case shows
    case movies
    case images
    case search
    case themes
    // MURRAY KEY
}

class DefaultUseCaseContainer: UseCaseContainer, DependencyContainer {
    var container = Container<UseCaseKeys>()

    var splash: SplashUseCase { self[.splash] }
    var login: LoginUseCase { self[.login] }
    var shows: ShowsContainer { self[.shows] }
    var movies: MoviesContainer { self[.movies] }
    var images: ImagesUseCase { self[.images] }
    var search: SearchUseCase { self[.search] }
    var themes: ThemeUseCase { self[.themes] }
    // MURRAY VAR

    init(container: ModelDependencyContainer) {
        register(for: .splash) {
            SplashUseCaseImplementation()
        }
        register(for: .login, scope: .singleton) {
            LoginUseCaseImplementation(authorization: container.repositories.authorization)
        }
        register(for: .shows, scope: .singleton) {
            ShowsContainerImplementation(container: container)
        }
        register(for: .movies, scope: .singleton) {
            MoviesContainerImplementation(container: container)
        }
        register(for: .search, scope: .singleton) {
            SearchUseCaseImplementation(repository: container.repositories.search)
        }
        register(for: .images, scope: .singleton) {
            ImagesUseCaseImplementation(configuration: container.repositories.configuration,
                                        shows: container.repositories.shows,
                                        movies: container.repositories.movies)
        }
        register(for: .themes, scope: .singleton) {
            ThemeUseCaseImplementation(repository: container.repositories.themes)
        }
        // MURRAY REGISTER
    }
}

public protocol ShowsContainer {
    var trending: ItemListUseCase { get }
    var popular: ItemListUseCase { get }
    var watched: ItemListUseCase { get }
    var collected: ItemListUseCase { get }
    var anticipated: ItemListUseCase { get }
    var detail: ShowDetailUseCase { get }
    var person: PersonDetailUseCase { get }
}

class ShowsContainerImplementation: ShowsContainer, DependencyContainer {
    enum Keys {
        case trending
        case popular
        case watched
        case collected
        case anticipated
        case detail
        case person
    }

    var container = Container<Keys>()

    var trending: ItemListUseCase { self[.trending] }
    var popular: ItemListUseCase { self[.popular] }
    var watched: ItemListUseCase { self[.watched] }
    var collected: ItemListUseCase { self[.collected] }
    var anticipated: ItemListUseCase { self[.anticipated] }
    var detail: ShowDetailUseCase { self[.detail] }
    var person: PersonDetailUseCase { self[.person] }

    init(container: ModelDependencyContainer) {
        register(for: .trending, scope: .singleton) { TrendingShowsUseCase(repository: container.repositories.shows) }
        register(for: .popular, scope: .singleton) { PopularShowsUseCase(repository: container.repositories.shows) }
        register(for: .watched, scope: .singleton) { WatchedShowsUseCase(repository: container.repositories.shows) }
        register(for: .collected, scope: .singleton) { CollectedShowsUseCase(repository: container.repositories.shows) }
        register(for: .anticipated, scope: .singleton) { AnticipatedShowsUseCase(repository: container.repositories.shows) }
        register(for: .detail, scope: .singleton) { ShowDetailUseCaseImplementation(shows: container.repositories.shows) }
        register(for: .person, scope: .singleton) { ShowPersonDetailUseCaseImplementation(shows: container.repositories.shows) }
    }
}

public protocol MoviesContainer {
    var trending: ItemListUseCase { get }
    var popular: ItemListUseCase { get }
    var watched: ItemListUseCase { get }
    var collected: ItemListUseCase { get }
    var anticipated: ItemListUseCase { get }
    var detail: MovieDetailUseCase { get }
    var person: PersonDetailUseCase { get }
}

class MoviesContainerImplementation: MoviesContainer, DependencyContainer {
    enum Keys {
        case trending
        case popular
        case watched
        case collected
        case anticipated
        case detail
        case person
    }

    var container = Container<Keys>()

    var trending: ItemListUseCase { self[.trending] }
    var popular: ItemListUseCase { self[.popular] }
    var watched: ItemListUseCase { self[.watched] }
    var collected: ItemListUseCase { self[.collected] }
    var anticipated: ItemListUseCase { self[.anticipated] }
    var detail: MovieDetailUseCase { self[.detail] }
    var person: PersonDetailUseCase { self[.person] }

    init(container: ModelDependencyContainer) {
        register(for: .trending, scope: .singleton) { TrendingMoviesUseCase(repository: container.repositories.movies) }
        register(for: .popular, scope: .singleton) { PopularMoviesUseCase(repository: container.repositories.movies) }
        register(for: .watched, scope: .singleton) { WatchedMoviesUseCase(repository: container.repositories.movies) }
        register(for: .collected, scope: .singleton) { CollectedMoviesUseCase(repository: container.repositories.movies) }
        register(for: .anticipated, scope: .singleton) { AnticipatedMoviesUseCase(repository: container.repositories.movies) }
        register(for: .detail, scope: .singleton) { MovieDetailUseCaseImplementation(movies: container.repositories.movies) }
        register(for: .person, scope: .singleton) { MoviePersonDetailUseCaseImplementation(movies: container.repositories.movies) }
    }
}
