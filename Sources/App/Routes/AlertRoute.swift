//
//  AlertRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct AlertRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    init(title: String) {
        self.createViewController = {
            let controller = UIAlertController(title: title, message: "This is a message", preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return controller
        }
    }
    func execute<T: UIViewController>(from scene: T?) {
        if let destination = createViewController() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}
