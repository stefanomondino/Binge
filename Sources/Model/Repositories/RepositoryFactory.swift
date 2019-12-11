//
//  Repositories.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol RepositoryFactory {
    var shows: ShowsRepository { get }
    var authorization: AuthorizationRepository { get }
    var configuration: ConfigurationRepository { get }
}

enum RepositoryKeys: CaseIterable, Hashable {
    case shows
    case authorization
    case configuration
}

class DefaultRepositoryFactory: RepositoryFactory, DependencyContainer {
    var shows: ShowsRepository { self[.shows]}
    var configuration: ConfigurationRepository { self[.configuration] }
    var authorization: AuthorizationRepository { self[.authorization] }
    var container = Container<RepositoryKeys>()
    
    init(dependencyContainer: ModelDependencyContainer) {
        
        self.register(for: .authorization, scope: .singleton) { DefaultAuthorizationRepository(dataSource: dependencyContainer.dataSources.rest) }
        self.register(for: .shows, scope: .singleton) { ShowsAPIRepository(rest: dependencyContainer.dataSources.rest) }
        self.register(for: .configuration, scope: .singleton) { ConfigurationAPIRepository(rest: dependencyContainer.dataSources.rest) }
    }
}
