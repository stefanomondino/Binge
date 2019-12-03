//
//  RestartRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

public struct RestartRoute: Route {
    public let createScene: () -> Scene?
    public init(createScene: @escaping () -> Scene) {
        self.createScene = createScene
    }
    
    public func execute(from scene: Scene?) {
        
        //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = createScene()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    public init(factory: CoreSceneFactory) {
        
        self.createScene = {
            
            return factory.root()
            
        }
    }
}
