//
//  ExitRoute.swift
//  Skeleton
//
//  Created by Stefano Mondino on 15/07/2020.
//

import Boomerang
import Foundation
import RxRelay

struct ExitRoute: UIKitRoute, CompletableRoute {
    var onCompleteRelay: PublishRelay<Bool> = PublishRelay()
    let createViewController: () -> UIViewController? = { nil }
    init() {}

    func execute<T: UIViewController>(from scene: T?) {
        if let navigation = scene?.navigationController,
            navigation.children.count > 1 {
            navigation.popViewController(animated: true)
        } else {
            scene?.dismiss(animated: true, completion: {
                self.onCompleteRelay.accept(true)
            })
        }
    }
}
