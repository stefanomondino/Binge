//
//  UIViewController+Rx.swift
//  App
//
//  Created by Stefano Mondino on 20/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    func viewDidLoad() -> Observable<()> {
        return methodInvoked(#selector(UIViewController.viewDidLoad)).map {_ in return ()}
    }
    func viewDidAppear() -> Observable<()> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:))).map {_ in return ()}
    }
    func viewWillAppear() -> Observable<()> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map {_ in return ()}
    }
    func viewDisappear() -> Observable<()> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).map {_ in return ()}
    }
    func viewWillDisappear() -> Observable<()> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).map {_ in return ()}
    }
    func viewWillLayoutSubviews() -> Observable<()> {
        return methodInvoked(#selector(UIViewController.viewWillLayoutSubviews)).map {_ in return ()}
    }
}
