//
//  DataSourceFactory.swift
//  Model
//
//  Created by Stefano Mondino on 21/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

typealias TraktTVDataSource = RESTDataSource
typealias TMDBDataSource = RESTDataSource
protocol DataSourceFactory {
    var rest: RESTDataSource { get }

}
enum DataSourceKeys: CaseIterable, Hashable {
    
    case rest
}

class DefaultDataSourceFactory: DataSourceFactory, DependencyContainer {
    var container = Container<DataSourceKeys>()

    var rest: RESTDataSource { self[.rest] }
    
    typealias Key = DataSourceKeys
    
    init(dependencyContainer: ModelDependencyContainer) {
        
        self.register(for: .rest, scope: .eagerSingleton) { DefaultRESTDataSource() }
    }
    
}
