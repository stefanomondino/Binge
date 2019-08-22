//
//  UIViewController+Navigation.swift
//  App
//
//  Created by Stefano Mondino on 20/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = true
        
        self.navigationBar.setBackgroundImage(UIImage.navbar(), for: .default)
        //        self.navigationBar.tintColor = .white
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Fonts.secondary(.bold).font(size: 20)
        ]
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension Reactive where Base: UINavigationController {
    func alpha() -> Binder<CGFloat> {
        return Binder(base) { base, alpha in
            base.navigationBar.setBackgroundImage(UIImage.navbar(alpha: alpha), for: .default)
        }
    }
    func bindAlpha(to scroll: UIScrollView, height: CGFloat = 200) -> Disposable {
        return scroll.rx.contentOffset
            .map { $0.y / height }
            .map { min(max(0, $0), 1)}
            .bind(to: alpha())
    }
}

extension UIViewController {
    func embedded(in navigation: UINavigationController.Type = NavigationController.self) -> UINavigationController {
        return navigation.init(rootViewController: self)
    }
}
