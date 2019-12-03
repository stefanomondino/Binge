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
import Core

protocol AppDependencyContainer  {
    var core: CoreDependencyContainer { get }
    var environment: Environment { get }
    var routeFactory: RouteFactory { get }
    var viewFactory: ViewFactory { get }
    var styleFactory: StyleFactory { get }
    var collectionViewCellFactory: CollectionViewCellFactory { get }
    var viewControllerFactory: ViewControllerFactory { get }
    var sceneViewModelFactory: SceneViewModelFactory { get }
    var translations: StringsFactory { get }
    var itemViewModelFactory: ItemViewModelFactory { get }
    var pickerViewModelFactory: PickerViewModelFactory { get }
    var model: UseCaseDependencyContainer { get }
}

enum DependencyContainerKeys: String, CaseIterable, Hashable {
    case routeFactory
    case collectionViewCellFactory
    case viewFactory
    case viewControllerFactory
    case sceneViewModelFactory
    case itemViewModelFactory
    case pickerViewModelFactory
    case styleFactory
    case translations
    case model
    case core
}

class DefaultAppDependencyContainer: AppDependencyContainer, DependencyContainer {
    
    var container = Container<DependencyContainerKeys>()
    
    let environment: Environment = MainEnvironment()
    
    var core: CoreDependencyContainer { self[.core] }
    var model: UseCaseDependencyContainer { self[.model] }
    var routeFactory: RouteFactory { self[.routeFactory] }
    var viewFactory: ViewFactory { self[.viewFactory] }
    var styleFactory: StyleFactory { self[.styleFactory] }
    var translations: StringsFactory { self[.translations] }
    var viewControllerFactory: ViewControllerFactory { self[.viewControllerFactory] }
    var collectionViewCellFactory: CollectionViewCellFactory { self[.collectionViewCellFactory] }
    var sceneViewModelFactory: SceneViewModelFactory { self[.sceneViewModelFactory] }
    var itemViewModelFactory: ItemViewModelFactory { self[.itemViewModelFactory] }
    var pickerViewModelFactory: PickerViewModelFactory { self[.pickerViewModelFactory] }
    
    init() {
        
        
        
        self.register(for: .translations, scope: .eagerSingleton) { StringsFactory(container: self) }
        self.register(for: .routeFactory) { MainRouteFactory(container: self) }
        self.register(for: .styleFactory, scope: .singleton) { DefaultStyleFactory(container: self) }
        self.register(for: .viewFactory) { DefaultViewFactory() }
        self.register(for: .collectionViewCellFactory) { DefaultCollectionViewCellFactory(viewFactory: self.viewFactory) }
        self.register(for: .viewControllerFactory) { DefaultViewControllerFactory(container: self) }
        self.register(for: .sceneViewModelFactory) { DefaultSceneViewModelFactory(container: self) }
        self.register(for: .itemViewModelFactory) { DefaultItemViewModelFactory(container: self) }
        self.register(for: .pickerViewModelFactory) { self.core.pickerViewModelFactory }
        self.register(for: .model, scope: .singleton) { DefaultModelDependencyContainer(environment: self.environment) }
        self.register(for: .core, scope: .singleton) { DefaultCoreDependencyContainer(sceneFactory: self.viewControllerFactory, routeFactory: self.routeFactory, model: self.model) }
        
    }
}
