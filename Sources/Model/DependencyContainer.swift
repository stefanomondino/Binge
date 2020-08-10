//
//  DependencyContainer.swift
//  Model
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
@_exported import Core
import Foundation
import Moya

public protocol Handlers {
    func onExternalURL(_ url: URL)
}

public protocol ModelContainer {
    var handlers: Handlers { get }
    var useCases: UseCaseContainer { get }
}

protocol ModelDependencyContainer: ModelContainer {
    var dataSources: DataSourceContainer { get }
    var repositories: RepositoryContainer { get }
}

public enum ModelDependencyContainerKeys: CaseIterable, Hashable {
    case dataSources
    case repositories
    case useCases
    case handlers
}

public class DefaultModelDependencyContainer: ModelDependencyContainer, DependencyContainer {
    public let container = Container<ModelDependencyContainerKeys>()
    public var handlers: Handlers { return self[.handlers] }
    public var useCases: UseCaseContainer { return self[.useCases] }
    var dataSources: DataSourceContainer { return self[.dataSources] }
    var repositories: RepositoryContainer { return self[.repositories] }
    public init(environment: Environment) {
        Configuration.environment = environment
        register(for: .dataSources, scope: .eagerSingleton) { DefaultDataSourceContainer(container: self) }
        register(for: .repositories, scope: .singleton) { DefaultRepositoryContainer(container: self) }
        register(for: .useCases, scope: .singleton) { DefaultUseCaseContainer(container: self) }

        register(for: .handlers, scope: .singleton) { DefaultHandlers(container: self) }
    }
}

/// Convert in Test, this is temporary
extension DefaultModelDependencyContainer {
    func testAll() {
        ModelDependencyContainerKeys.allCases.forEach {
            // expect no throw
            let value: Any = self[$0]
            print(value)
        }
    }
}
