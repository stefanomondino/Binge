//
//  DataSourceFactory.swift
//  Model
//
//  Created by Stefano Mondino on 21/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Moya

protocol DataSourceFactory {
    var traktv: TraktTVDataSource { get }
    var tmdb: TMDBDataSource { get }
}
enum DataSourceKeys: CaseIterable, Hashable {
    case traktv
    case tmdb
}

class DefaultDataSourceFactory: DataSourceFactory, DependencyContainer {
    var container = Container<DataSourceKeys>()
    
    var traktv: TraktTVDataSource { self[.traktv] }
    
    var tmdb: TMDBDataSource { self[.tmdb] }
    
    typealias Key = DataSourceKeys
    
    init(dependencyContainer: ModelDependencyContainer) {
        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.formatRequestAscURL]))
        self.register(for: .traktv) { MoyaProvider<TraktvAPI>(plugins: [networkLoggerPlugin]) }
        self.register(for: .tmdb) { MoyaProvider<TMDBAPI>(plugins: [networkLoggerPlugin]) }
    }
    
}
