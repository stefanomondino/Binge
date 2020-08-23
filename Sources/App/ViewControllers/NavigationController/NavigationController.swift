//
//  NavigationController.swift
//  App
//
//  Created by Stefano Mondino on 19/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxCocoa
import RxRelay
import RxSwift
import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        #if os(iOS)
            interactivePopGestureRecognizer?.delegate = self
            setNeedsStatusBarAppearanceUpdate()
        #endif
    }

    #if os(iOS)
        override var preferredStatusBarStyle: UIStatusBarStyle {
            topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
        }

        override var childForStatusBarStyle: UIViewController? {
            topViewController
        }
    #endif
}

extension UIViewController {
    func inNavigationController() -> UIViewController {
        return NavigationController(rootViewController: self)
    }
}
