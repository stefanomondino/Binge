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
struct EmptyRoute: UIKitRoute {
    var createViewController: () -> UIViewController?
    func execute<T: UIViewController>(from scene: T?) {}
}
