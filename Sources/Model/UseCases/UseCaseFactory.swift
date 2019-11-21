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
    
//    let dependencyContainer: ModelDependencyContainer
    var splash: SplashUseCase { self[.splash] }
    var popularShows: ShowListUseCase { self[.popularShows]}
    var trendingShows: ShowListUseCase { self[.trendingShows] }
    
    init (showsRepository: ShowsRepository) {
        self.register(for: .splash) { DefaultSplashUseCase() }
        self.register(for: .popularShows) { PopularShowsUseCase(repository: showsRepository)}
        self.register(for: .trendingShows) { TrendingShowsUseCase(repository: showsRepository)}
    }
    
    subscript<T>(index: Key) -> T {
        guard let element: T = resolve(index) else {
            fatalError("No dependency found for \(index)")
        }
        
        return element
    }
}
