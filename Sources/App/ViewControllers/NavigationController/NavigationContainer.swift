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

class NavigationContainer: UIViewController {
    let disposeBag = DisposeBag()
    var styleFactory: StyleFactory
    let rootViewController: UIViewController
    let navbarContainer: UIView = UIView()
    let navbar: UIView
    var navigationBarColor: UIColor = .clear {
        didSet {
            updateNavbarAlpha(1)
        }
    }

    func updateNavbarAlpha(_ alpha: CGFloat) {
        let alpha = max(0, min(alpha, 0.99))
        let color = navigationBarColor.withAlphaComponent(alpha)
        navbarContainer.backgroundColor = color
    }

    init(rootViewController: UIViewController,
         styleFactory: StyleFactory,
         navbar: UIView = UIView()) {
        self.styleFactory = styleFactory
        self.navbar = navbar
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navbarContainer)
        navbarContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let stackView = UIStackView()

        navbarContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(navbarContainer.safeAreaLayoutGuide.snp.top)
            make.height.greaterThanOrEqualTo(44)
        }

        if let navigation = navigationController,
            navigation.viewControllers.count > 1 {
            let button = UIButton(type: .system)
            button.setTitle("BACK", for: .normal)
            stackView.addArrangedSubview(button)
            button.rx.tap
                .bind { navigation.popViewController(animated: true) }
                .disposed(by: disposeBag)
        }

        stackView.addArrangedSubview(navbar)
        addChild(rootViewController)
        view.insertSubview(rootViewController.view, at: 0)
        rootViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        styleFactory.apply(Styles.Generic.navigationBar, to: self)
        updateCurrentScroll(0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootViewController.additionalSafeAreaInsets.top = navbar.bounds.height
    }

    func updateCurrentScroll(_ value: CGFloat) {
        let value = max(0, min(1, value))
        updateNavbarAlpha(1 - value)
    }
}

extension Reactive where Base: NavigationContainer {
    func updateCurrentScroll() -> Binder<CGFloat> {
        return Binder(base) { $0.updateCurrentScroll($1) }
    }
}

extension UIViewController {
    var container: NavigationContainer? {
        return (self as? NavigationContainer) ?? parent?.container
    }

    func inContainer(styleFactory: StyleFactory) -> NavigationContainer {
        return NavigationContainer(rootViewController: self, styleFactory: styleFactory)
    }
}
