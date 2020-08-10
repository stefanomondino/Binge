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
    // MURRAY PROTOCOL
}

class DefaultRepositoryContainer: RepositoryContainer, DependencyContainer {
    enum Keys: CaseIterable, Hashable {
        case authorization
        case configuration
        case shows
        // MURRAY KEY
    }

    var configuration: ConfigurationRepository { self[.configuration] }
    var authorization: AuthorizationRepository { self[.authorization] }
    var shows: ShowsRepository { self[.shows] }
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
        // MURRAY REGISTER
    }
}
