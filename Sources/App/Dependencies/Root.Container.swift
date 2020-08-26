//
//  DependencyContainer.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import RxSwift

protocol RootContainer {
    var environment: Environment { get }
    var viewModels: ViewModelContainer { get }
    var views: ViewContainer { get }
    var routeFactory: RouteFactory { get }
    var styleFactory: StyleFactory { get }
    var translations: StringsFactory { get }
    var model: ModelContainer { get }
}

class InitializationRoot: RootContainer, DependencyContainer {
    enum Keys: String, CaseIterable, Hashable {
        case routeFactory
        case viewModels
        case views
        case styleFactory
        case translations
        case model
    }

    let container = Container<Keys>()

    let environment: Environment = MainEnvironment()
    var views: ViewContainer { self[.views] }
    var model: ModelContainer { self[.model] }
    var viewModels: ViewModelContainer { self[.viewModels] }
    var routeFactory: RouteFactory { self[.routeFactory] }
    var styleFactory: StyleFactory { self[.styleFactory] }
    var translations: StringsFactory { self[.translations] }

    init() {
        Logger.shared.add(logger: ConsoleLogger(logLevel: .verbose))

        register(for: .translations, scope: .eagerSingleton) { StringsFactory(container: self) }
        register(for: .routeFactory, scope: .singleton) { MainRouteFactory(container: self) }
        register(for: .styleFactory, scope: .singleton) { StyleFactoryAlias(container: self) }

        register(for: .viewModels, scope: .singleton) { self.viewModelImplementation() }
        register(for: .views, scope: .singleton) { self.viewImplementation() }
        register(for: .model, scope: .eagerSingleton) { DefaultModelDependencyContainer(environment: self.environment) }
    }
}
