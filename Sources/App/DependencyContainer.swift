//
//  DependencyContainer.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model

protocol AppDependencyContainer  {
    var routeFactory: RouteFactory { get }
    var viewFactory: ViewFactory { get }
    var collectionViewCellFactory: CollectionViewCellFactory { get }
    var viewControllerFactory: ViewControllerFactory { get }
    var sceneViewModelFactory: SceneViewModelFactory { get }
    var itemViewModelFactory: ItemViewModelFactory { get }
    var model: ModelDependencyContainer { get }
}

enum DependencyContainerKeys: CaseIterable, Hashable {
    case routeFactory
    case collectionViewCellFactory
    case viewFactory
    case viewControllerFactory
    case sceneViewModelFactory
    case itemViewModelFactory
    case model
}


class DefaultAppDependencyContainer: AppDependencyContainer, DependencyContainer {
    typealias Key = DependencyContainerKeys
    
    var container: [Key: () -> Any ] = [:]
    
    var model: ModelDependencyContainer { self[.model] }
    var routeFactory: RouteFactory { self[.routeFactory] }
    var viewFactory: ViewFactory { self[.viewFactory] }
    var viewControllerFactory: ViewControllerFactory { self[.viewControllerFactory] }
    var collectionViewCellFactory: CollectionViewCellFactory { self[.collectionViewCellFactory] }
    var sceneViewModelFactory: SceneViewModelFactory { self[.sceneViewModelFactory] }
    var itemViewModelFactory: ItemViewModelFactory { self[.itemViewModelFactory] }
    init() {
        self.register(for: .routeFactory) { MainRouteFactory(container: self) }
        self.register(for: .viewFactory) { MainViewFactory()}
        self.register(for: .collectionViewCellFactory) { MainCollectionViewCellFactory(viewFactory: self.viewFactory) }
        self.register(for: .viewControllerFactory) { DefaultViewControllerFactory(container: self) }
        self.register(for: .sceneViewModelFactory) { DefaultSceneViewModelFactory(container: self) }
        self.register(for: .itemViewModelFactory) { DefaultItemViewModelFactory(container: self) }
        self.register(for: .model) { DefaultModelDependencyContainer() }
    }
    
    subscript<T>(index: Key) -> T {
        guard let element: T = resolve(index) else {
            fatalError("No dependency found for \(index)")
        }
        
        return element
    }
}
