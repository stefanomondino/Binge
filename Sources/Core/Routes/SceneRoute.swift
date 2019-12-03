//
//  SceneRoute.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import UIKit
/**
    A simple route to create generic scenes.
    Executing this kind of route does nothing.
 */
public struct EmptyRoute: Route {
    
    public let createScene: () -> Scene?
    public func execute(from scene: Scene?) {}
    
    public init(createScene: @escaping () -> Scene) {
        self.createScene = createScene
    }
}
