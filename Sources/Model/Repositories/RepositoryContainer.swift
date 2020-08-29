//
//  Repositories.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

protocol RepositoryContainer {
    var authorization: AuthorizationRepository { get }
    var configuration: ConfigurationRepository { get }
    var shows: ShowsRepository { get }
    var movies: MoviesRepository { get }
    var search: SearchRepository { get }
    var themes: ThemeRepository { get }
    var profile: ProfileRepository { get }
    // MURRAY PROTOCOL
}

class DefaultRepositoryContainer: RepositoryContainer, DependencyContainer {
    enum Keys: CaseIterable, Hashable {
        case authorization
        case configuration
        case shows
        case movies
        case search
        case themes
        case profile
        // MURRAY KEY
    }

    var configuration: ConfigurationRepository { self[.configuration] }
    var authorization: AuthorizationRepository { self[.authorization] }
    var shows: ShowsRepository { self[.shows] }
    var movies: MoviesRepository { self[.movies] }
    var search: SearchRepository { self[.search] }
    var themes: ThemeRepository { self[.themes] }
    var profile: ProfileRepository { self[.profile] }
    // MURRAY VAR

    var container = Container<Keys>()

    init(container: ModelDependencyContainer) {
        register(for: .authorization, scope: .singleton) {
            DefaultAuthorizationRepository(dataSource: container.dataSources.rest)
        }
        register(for: .configuration, scope: .singleton) {
            ConfigurationAPIRepository(rest: container.dataSources.rest)
        }
        register(for: .shows, scope: .singleton) {
            ShowsRepositoryImplementation(rest: container.dataSources.rest)
        }
        register(for: .movies, scope: .singleton) {
            MoviesRepositoryImplementation(rest: container.dataSources.rest)
        }
        register(for: .search, scope: .singleton) {
            SearchRepositoryImplementation(rest: container.dataSources.rest)
        }
        register(for: .themes, scope: .singleton) {
            DefaultThemeRepository(properties: container.dataSources.properties)
        }
        register(for: .profile, scope: .singleton) {
            ProfileRepositoryImplementation(rest: container.dataSources.rest, authorization: self.authorization)
        }
        // MURRAY REGISTER
    }
}
