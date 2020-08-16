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
    var images: ImagesUseCase { get }
    // MURRAY PROTOCOL
}

enum UseCaseKeys: CaseIterable, Hashable {
    case splash
    case login
    case shows
    case images
    // MURRAY KEY
}

class DefaultUseCaseContainer: UseCaseContainer, DependencyContainer {
    var container = Container<UseCaseKeys>()

    var splash: SplashUseCase { self[.splash] }
    var login: LoginUseCase { self[.login] }
    var shows: ShowsContainer { self[.shows] }
    var images: ImagesUseCase { self[.images] }
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
        register(for: .images, scope: .singleton) {
            ImagesUseCaseImplementation(configuration: container.repositories.configuration, shows: container.repositories.shows)
        }
        // MURRAY REGISTER
    }
}

public protocol ShowsContainer {
    var trending: ShowListUseCase { get }
    var popular: ShowListUseCase { get }
    var watched: ShowListUseCase { get }
    var collected: ShowListUseCase { get }
    var anticipated: ShowListUseCase { get }
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

    var trending: ShowListUseCase { self[.trending] }
    var popular: ShowListUseCase { self[.popular] }
    var watched: ShowListUseCase { self[.watched] }
    var collected: ShowListUseCase { self[.collected] }
    var anticipated: ShowListUseCase { self[.anticipated] }
    var detail: ShowDetailUseCase { self[.detail] }
    var person: PersonDetailUseCase { self[.person] }

    init(container: ModelDependencyContainer) {
        register(for: .trending, scope: .singleton) { TrendingShowsUseCase(repository: container.repositories.shows) }
        register(for: .popular, scope: .singleton) { PopularShowsUseCase(repository: container.repositories.shows) }
        register(for: .watched, scope: .singleton) { WatchedShowsUseCase(repository: container.repositories.shows) }
        register(for: .collected, scope: .singleton) { CollectedShowsUseCase(repository: container.repositories.shows) }
        register(for: .anticipated, scope: .singleton) { AnticipatedShowsUseCase(repository: container.repositories.shows) }
        register(for: .detail, scope: .singleton) { ShowDetailUseCaseImplementation(shows: container.repositories.shows) }
        register(for: .person, scope: .singleton) { PersonDetailUseCaseImplementation(shows: container.repositories.shows) }
    }
}
