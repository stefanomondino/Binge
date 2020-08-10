//
//  SafariRoute.swift
//  App
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxRelay
import SafariServices

struct SafariRoute: UIKitRoute, CompletableRoute {
    var onCompleteRelay: PublishRelay<Bool> = PublishRelay()
    let createViewController: () -> UIViewController?
    let url: URL
    init(url: URL) {
        createViewController = { nil }
        self.url = url
    }

    func execute<T: UIViewController>(from scene: T?) {
        let viewController = SFSafariViewController(url: url)
        scene?.present(viewController, animated: true, completion: { self.onCompleteRelay.accept(true) })
    }
}
