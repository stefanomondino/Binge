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
    var watchedShows: ShowListUseCase { get }
    var images: ImagesUseCase { get }
}

enum UseCaseKeys: CaseIterable, Hashable {
    case splash
    case images
    case popularShows
    case trendingShows
    case watchedShows
}

class DefaultUseCaseFactory: UseCaseFactory, DependencyContainer {
    var container = Container<UseCaseKeys>()

    var splash: SplashUseCase { self[.splash] }
    var popularShows: ShowListUseCase { self[.popularShows] }
    var watchedShows: ShowListUseCase { self[.watchedShows] }
    var trendingShows: ShowListUseCase { self[.trendingShows] }
    var images: ImagesUseCase { self[.images] }
    
    init (dependencyContainer: ModelDependencyContainer) {
        
        self.register(for: .splash) { DefaultSplashUseCase() }
        self.register(for: .images) { DefaultImagesUseCase(configuration: dependencyContainer.repositories.configuration,
                                                           shows: dependencyContainer.repositories.shows) }
        self.register(for: .popularShows) { PopularShowsUseCase(repository: dependencyContainer.repositories.shows)}
        self.register(for: .watchedShows) { WatchedShowsUseCase(repository: dependencyContainer.repositories.shows)}
        self.register(for: .trendingShows) { TrendingShowsUseCase(repository: dependencyContainer.repositories.shows) }
    }
}
