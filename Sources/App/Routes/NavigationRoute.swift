//
//  ModalRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import UIKit

struct NavigationRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    let animated: Bool
    init(animated: Bool = true, createViewController: @escaping () -> UIViewController) {
        self.animated = animated
        self.createViewController = createViewController
    }

    func execute<T>(from scene: T?) where T: UIViewController {
        guard let destination = createViewController() else { return }

        if let navigationController = scene?.navigationController {
            navigationController.pushViewController(destination, animated: animated)
        } else {
            scene?.showDetailViewController(destination, sender: nil)
        }
    }
}
