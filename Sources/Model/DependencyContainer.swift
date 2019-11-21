//
//  DependencyContainer.swift
//  Model
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Moya

public protocol UseCaseDependencyContainer {
    var imagesUseCase: ImagesUseCase { get }
    var useCases: UseCaseFactory { get }
}

protocol ModelDependencyContainer: UseCaseDependencyContainer  {

    var dataSources: DataSourceFactory { get }
    var repositories: RepositoryFactory { get }
}

public enum ModelDependencyContainerKeys: CaseIterable, Hashable {
    case imagesUseCase
    case dataSources
    case repositories
    case useCases
}

public class DefaultModelDependencyContainer: ModelDependencyContainer, DependencyContainer {
    public typealias Key = ModelDependencyContainerKeys
    
    public var container: [Key: () -> Any ] = [:]
    
    public var useCases: UseCaseFactory { return self[.useCases] }
    public var imagesUseCase: ImagesUseCase { return self[.imagesUseCase] }
     var dataSources: DataSourceFactory { return self[.dataSources] }
     var repositories: RepositoryFactory { return self[.repositories] }
     public init(environment: Environment) {
        Configuration.environment = environment

        self.register(for: .dataSources) { DefaultDataSourceFactory(dependencyContainer: self) }
        self.register(for: .repositories) { DefaultRepositoryFactory(dependencyContainer: self) }
        self.register(for: .useCases) { DefaultUseCaseFactory(dependencyContainer: self) }
    }
}

///Convert in Test, this is temporary
extension DefaultModelDependencyContainer {
    func testAll() {
        
        ModelDependencyContainerKeys.allCases.forEach {
            //expect no throw
            let v: Any = self[$0]
            print(v)            
        }
    }
}
