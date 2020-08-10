//
//  ModalRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxRelay
import UIKit

struct ModalRoute: UIKitRoute, CompletableRoute {
    var onCompleteRelay: PublishRelay<Bool> = PublishRelay()
    let createViewController: () -> UIViewController?
    init(createViewController: @escaping () -> UIViewController) {
        self.createViewController = createViewController
    }

    func execute<T: UIViewController>(from scene: T?) {
        if let destination = createViewController() {
            scene?.present(destination, animated: true, completion: { self.onCompleteRelay.accept(true) })
        }
    }
}
