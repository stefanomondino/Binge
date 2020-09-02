//
//  AppDelegate.swift
//  Skeleton
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
@UIApplicationMain

// An empty app to host tests
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        return window
    }()
}
