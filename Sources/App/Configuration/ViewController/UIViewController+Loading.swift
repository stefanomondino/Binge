//
//  UIViewController+Style.swift
//  App
//
//  Created by Stefano Mondino on 17/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Boomerang

extension Boomerang where Base: UIViewController {
    func showLoader() {
        print ("ShowingLoader")
    }
    func hideLoader() {
        print ("HidingLoader")
    }
}

extension Reactive where Base: UIViewController {
    func toggleLoader() -> Binder<Bool> {
        return Binder(base) { base, isLoading in
            isLoading ? base.boomerang.showLoader() : base.boomerang.hideLoader()
        }
    }
}
