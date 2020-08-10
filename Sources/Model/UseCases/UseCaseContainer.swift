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
}

class ShowsContainerImplementation: DependencyContainer {
    enum Keys {
        case trending
    }
    var container = Container<Keys>()
    
    init(container: ModelDependencyContainer) {
        register(for: .trending, scope: .singleton) { TrendingShowsUseCase(repository: container.repositories.shows)}
    }
}
