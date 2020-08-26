//
//  AlertRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxRelay
import UIKit
struct ErrorRoute: UIKitRoute, CompletableRoute {
    let onCompleteRelay: PublishRelay<Bool> = PublishRelay()
    let createViewController: () -> UIViewController?
    init(error: Errors, retry: (() -> Void)? = nil) {
        createViewController = {
            let controller = UIAlertController(title: "OOPS", message: error.localizedDescription, preferredStyle: .alert)
            if let retry = retry {
                controller.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in retry() }))
            }
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            return controller
        }
    }

    func execute<T: UIViewController>(from scene: T?) {
        if let destination = createViewController() {
            scene?.present(destination, animated: true, completion: { self.onCompleteRelay.accept(true) })
        }
    }
}
