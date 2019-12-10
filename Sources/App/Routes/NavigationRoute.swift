//
//  ModalRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct NavigationRoute: Route {
    let createScene: () -> Scene?
    let animated: Bool
    init(animated: Bool = true, createScene: @escaping () -> Scene) {
        self.animated = animated
        self.createScene = createScene
    }
    func execute(from scene: Scene?) {
        guard let navigationController = scene?.navigationController else { return }
        if let destination = createScene() {
            navigationController.pushViewController(destination, animated: animated)
            //scene?.present(destination, animated: true, completion: nil)
        }
    }
}

