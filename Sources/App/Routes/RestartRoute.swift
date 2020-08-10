//
//  RestartRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import UIKit

struct RestartRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    init(createViewController: @escaping () -> UIViewController) {
        self.createViewController = createViewController
    }

    func execute<T: UIViewController>(from scene: T?) {
        let scene = scene ?? UIApplication.shared.delegate?.window??.rootViewController

        if let presented = scene?.presentedViewController {
            execute(from: presented)
            return
        }

        if let presenting = scene?.presentingViewController {
            scene?.dismiss(animated: false) {
                self.execute(from: presenting)
            }
            return
        }

        UIApplication.shared.delegate?.window??.rootViewController = createViewController()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }

    init(factory: ViewControllerFactory) {
        createViewController = {
            factory.root()
        }
    }
}
