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
        interactivePopGestureRecognizer?.delegate = self
    }
}
