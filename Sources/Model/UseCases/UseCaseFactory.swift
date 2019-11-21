//
//  UseCases.swift
//  Model
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

//Enumerate here every use case
//public struct UseCases {
//    public static var splash: SplashUseCaseType = SplashUseCase()
//    public static var images: ImagesUseCaseType = ImagesUseCase()
//    
//    public static var showDetail: ShowDetailUseCaseType = ShowDetailUseCase()
//		//MURRAY PLACEHOLDER - DO NOT REMOVE
//}

public protocol UseCaseFactory {
    var splash: SplashUseCase { get }
    var popularShows: ShowListUseCase { get }
    var trendingShows: ShowListUseCase { get }
}

enum UseCaseKeys: CaseIterable, Hashable {
    case splash
    case popularShows
    case trendingShows
}

class DefaultUseCaseFactory: UseCaseFactory, DependencyContainer {
    var container: [UseCaseKeys : () -> Any] = [:]
    typealias Key = UseCaseKeys
    
    var splash: SplashUseCase { self[.splash] }
    var popularShows: ShowListUseCase { self[.popularShows]}
    var trendingShows: ShowListUseCase { self[.trendingShows] }
    
    init (dependencyContainer: ModelDependencyContainer) {
        
        self.register(for: .splash) { DefaultSplashUseCase() }
        self.register(for: .popularShows) { PopularShowsUseCase(repository: dependencyContainer.repositories.shows)}
        self.register(for: .trendingShows) { TrendingShowsUseCase(repository: dependencyContainer.repositories.shows) }
    }
}
