//
//  AppDelegate.swift
//  Skeleton
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
@_exported import Core
@_exported import Boomerang
//@_exported import RxBoomerang
//@_exported import UIKitBoomerang
@_exported import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let initializationRoot: RootContainer = InitializationRoot()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Logger.log("STARTING APP", tag: .lifecycle)
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        //Placeholder VC to avoid crashes
//        window.rootViewController = UIViewController()
        
//        window.makeKeyAndVisible()
        
        initializationRoot
                   .routeFactory
                   .restart()
                   .execute(from: window.rootViewController)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        initializationRoot.model.handlers.onExternalURL(url)
        return true
    }
    
}
