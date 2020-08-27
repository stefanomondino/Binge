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
}

enum DataSourceKeys: CaseIterable, Hashable {
    case rest
}

class DefaultDataSourceContainer: DataSourceContainer, DependencyContainer {
    var container = Container<DataSourceKeys>()

    var rest: RESTDataSource { self[.rest] }

    typealias Key = DataSourceKeys

    init(container _: ModelDependencyContainer) {
        let dataSource = CachingRESTDataSource()
        dataSource.addProvider(for: TMDB.API.self)
        dataSource.addProvider(for: TraktvAPI.self)
        dataSource.addProvider(for: FanartAPI.self)

        register(for: .rest, scope: .eagerSingleton) {
            dataSource
        }
    }
}
