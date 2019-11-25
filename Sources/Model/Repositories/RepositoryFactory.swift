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
    var configuration: ConfigurationRepository { get }
}

enum RepositoryKeys: CaseIterable, Hashable {
    case shows
    case configuration
}

class DefaultRepositoryFactory: RepositoryFactory, DependencyContainer {
    var shows: ShowsRepository { self[.shows]}
    var configuration: ConfigurationRepository { self[.configuration] }
    var container = Container<RepositoryKeys>()
    
    init(dependencyContainer: ModelDependencyContainer) {
        
        self.register(for: .shows, scope: .singleton) { ShowsAPIRepository(tmdb: dependencyContainer.dataSources.tmdb, traktv: dependencyContainer.dataSources.traktv) }
        self.register(for: .configuration, scope: .singleton) { ConfigurationAPIRepository(tmdb: dependencyContainer.dataSources.tmdb) }
    }
}
