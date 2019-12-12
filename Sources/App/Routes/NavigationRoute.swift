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

struct NavigationRoute: UIKitRoute {

    let createViewController: () -> UIViewController?
    let animated: Bool
    init(animated: Bool = true, createViewController: @escaping () -> UIViewController) {
        self.animated = animated
        self.createViewController = createViewController
    }
    func execute<T>(from scene: T?) where T : UIViewController {
        guard let navigationController = scene?.navigationController else { return }
        if let destination = createViewController() {
            navigationController.pushViewController(destination, animated: animated)
            //scene?.present(destination, animated: true, completion: nil)
        }
    }
}

