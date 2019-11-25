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

struct RestartRoute: Route {
    let createScene: () -> Scene?
    init(createScene: @escaping () -> Scene) {
        self.createScene = createScene
    }
    
    func execute(from scene: Scene?) {
        
        //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = createScene()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    init(factory: ViewControllerFactory) {
        
        self.createScene = {
            
            return factory.root()
            
        }
    }
}
