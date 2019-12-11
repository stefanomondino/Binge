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

struct SafariRoute: Route {
    let createScene: () -> Scene?
    let url: URL
    init(url: URL) {
        self.createScene = { nil }
        self.url = url
    }
    func execute(from scene: Scene?) {
        let vc = SFSafariViewController(url: url)
        scene?.present(vc, animated: true, completion: nil)
    }
}

