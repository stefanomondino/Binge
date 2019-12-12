//
//  SafariRoute.swift
//  App
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import SafariServices

struct SafariRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    let url: URL
    init(url: URL) {
        self.createViewController = { nil }
        self.url = url
    }
    func execute<T: UIViewController>(from scene: T?) {
        let vc = SFSafariViewController(url: url)
        scene?.present(vc, animated: true, completion: nil)
    }
}

