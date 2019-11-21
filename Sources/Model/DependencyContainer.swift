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

public protocol ModelDependencyContainer  {
    var imagesUseCase: ImagesUseCase { get }
    var useCases: UseCaseFactory { get }
}

public enum ModelDependencyContainerKeys: CaseIterable, Hashable {
    case trakTVDataSource
    case tmdbDataSource
    case showsRepository
    case configurationRepository
    
    case imagesUseCase
    
    case useCases
    
}


public class DefaultModelDependencyContainer: ModelDependencyContainer, DependencyContainer {
    public typealias Key = ModelDependencyContainerKeys
    
    public var container: [Key: () -> Any ] = [:]

    var trakTVDataSource: TraktTVDataSource { return self[.trakTVDataSource] }
    var tmdbDataSource: TMDBDataSource { return self[.tmdbDataSource] }
    var showsRepository: ShowsRepository { return self[.showsRepository] }
    var configurationRepository: ConfigurationRepository { return self[.configurationRepository] }
    
    public var useCases: UseCaseFactory { return self[.useCases] }
    public var imagesUseCase: ImagesUseCase { return self[.imagesUseCase] }
    public init(environment: Environment) {
        Configuration.environment = environment
        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.formatRequestAscURL]))
        self.register(for: .trakTVDataSource) { MoyaProvider<TraktvAPI>(plugins: [networkLoggerPlugin]) }
        self.register(for: .tmdbDataSource) { MoyaProvider<TMDBAPI>(plugins: [networkLoggerPlugin]) }
        self.register(for: .showsRepository) { ShowsAPIRepository(tmdb: self.tmdbDataSource, traktv: self.trakTVDataSource) }
        self.register(for: .configurationRepository) { ConfigurationAPIRepository(tmdb: self.tmdbDataSource) }
        
        
        self.register(for: .useCases) { DefaultUseCaseFactory(showsRepository: self.showsRepository) }
        self.register(for: .imagesUseCase) { DefaultImagesUseCase(configuration: self.configurationRepository, shows: self.showsRepository)}
        
    }
    
    subscript<T>(index: Key) -> T {
        guard let element: T = resolve(index) else {
            fatalError("No dependency found for \(index)")
        }
        
        return element
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
