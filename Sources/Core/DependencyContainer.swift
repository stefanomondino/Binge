//
//  DependencyContainer.swift
//  Model
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model

public protocol CoreDependencyContainer  {
    var pickerViewModelFactory: PickerViewModelFactory { get }
    var sceneFactory: CoreSceneFactory { get }
    var model: UseCaseDependencyContainer { get }
    var routeFactory: CoreRouteFactory { get }
}

public enum CoreDependencyContainerKeys: CaseIterable, Hashable {
    case pickerViewModelFactory
    case sceneFactory
    case routeFactory
    case model
}

public class DefaultCoreDependencyContainer: CoreDependencyContainer, DependencyContainer {
    
    public let container = Container<CoreDependencyContainerKeys>()
    
    public var pickerViewModelFactory: PickerViewModelFactory { return self[.pickerViewModelFactory] }
    public var sceneFactory: CoreSceneFactory { return self[.sceneFactory] }
    public var routeFactory: CoreRouteFactory { return self[.routeFactory] }
    public var model: UseCaseDependencyContainer { self[.model] }
    public init(sceneFactory: CoreSceneFactory,
                routeFactory: CoreRouteFactory,
                model: UseCaseDependencyContainer) {
        
        self.register(for: .pickerViewModelFactory, scope: .singleton) { DefaultPickerViewModelFactory() }
        self.register(for: .sceneFactory) { sceneFactory }
        self.register(for: .routeFactory) { routeFactory }
        self.register(for: .model) { model }
    }
}

///Convert in Test, this is temporary
extension DefaultCoreDependencyContainer {
    func testAll() {
        
        CoreDependencyContainerKeys.allCases.forEach {
            //expect no throw
            let v: Any = self[$0]
            print(v)            
        }
    }
}
