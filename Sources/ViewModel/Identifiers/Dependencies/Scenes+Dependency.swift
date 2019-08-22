//
//  Scenes+Dependency.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public struct SceneContainer: DependencyContainer {
    public static var container = Container<Int, Identifiers.Scenes.Parameters>()
}

extension Identifiers.Scenes: SceneIdentifier {
    
    public struct Parameters {
        public var scene: (() -> Scene?)
        public var name: String?
        public init(name: String? = nil, scene: @escaping (() -> Scene?)) {
            self.scene = scene
            self.name = name
        }
    }
    public func scene<T>() -> T? where T: Scene {
        return SceneContainer.resolve(self)?.scene() as? T
    }
    
    public var name: String {
        return SceneContainer.resolve(self)?.name ?? self.rawValue
    }
}
