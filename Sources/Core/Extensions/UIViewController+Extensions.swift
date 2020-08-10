//
//  UIViewController+Rx.swift
//  App
//
//  Created by Stefano Mondino on 11/02/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    func viewDidLoad() -> Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in () }
    }

    func viewDidAppear() -> Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:))).map { _ in () }
    }

    func viewWillAppear() -> Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map { _ in () }
    }

    func viewDisappear() -> Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).map { _ in () }
    }

    func viewWillDisappear() -> Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).map { _ in () }
    }

    func viewWillLayoutSubviews() -> Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillLayoutSubviews)).map { _ in () }
    }
}
