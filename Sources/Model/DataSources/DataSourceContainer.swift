//
//  DataSourceFactory.swift
//  Model
//
//  Created by Stefano Mondino on 21/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

protocol DataSourceContainer {
    func register<Value: Any>(for key: DataSourceKeys, scope: Container<DataSourceKeys>.Scope, handler: @escaping () -> Value)
    var rest: RESTDataSource { get }
    var properties: UserPropertyDataSource { get }
}

enum DataSourceKeys: CaseIterable, Hashable {
    case rest
    case properties
}

class DefaultDataSourceContainer: DataSourceContainer, DependencyContainer {
    var container = Container<DataSourceKeys>()

    var rest: RESTDataSource { self[.rest] }
    var properties: UserPropertyDataSource { self[.properties] }

    typealias Key = DataSourceKeys

    init(container _: ModelDependencyContainer) {
        let dataSource = CachingRESTDataSource()
        dataSource.addProvider(for: TMDB.API.self)
        dataSource.addProvider(for: Trakt.API.self)
        dataSource.addProvider(for: FanartAPI.self)

        register(for: .rest, scope: .eagerSingleton) {
            dataSource
        }
        register(for: .properties, scope: .singleton) {
            LocalUserPropertyDataSource()
        }
    }
}
