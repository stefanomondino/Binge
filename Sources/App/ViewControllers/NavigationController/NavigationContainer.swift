//
//  NavigationController.swift
//  App
//
//  Created by Stefano Mondino on 19/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class NavigationContainer: UIViewController {
    enum Position {
        case left
        case center
        case right
    }

    let disposeBag = DisposeBag()
    let rootViewController: UIViewController
    let navbarContainer: UIView = UIView()
    let titleContainer = UIView()
    let leftContainer = UIStackView()
    let rightContainer = UIStackView()
    weak var currentTitleView: UIView?
    weak var heightConstraint: NSLayoutConstraint?
    var extendUnderNavbar: Bool {
        didSet {
            adjustInnerSafeAreaInsets()
        }
    }

    var navigationBarMinHeight: CGFloat = 64 {
        didSet {
            heightConstraint?.constant = navigationBarMinHeight
            view.layoutIfNeeded()
        }
    }

    var navigationBarColor: UIColor = .clear {
        didSet {
            updateNavbarAlpha(1)
        }
    }

    func updateNavbarAlpha(_ alpha: CGFloat) {
        let alpha = max(0, min(alpha, 0.99))
        let color = navigationBarColor.withAlphaComponent(alpha)
        navbarContainer.backgroundColor = color
        titleContainer.alpha = alpha
    }

    init(rootViewController: UIViewController,
         extendUnderNavbar: Bool) {
        self.extendUnderNavbar = extendUnderNavbar
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addButton(_ view: UIView, position: Position) {
        view.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        if let button = view as? UIButton {
            button.imageView?.contentMode = .scaleAspectFit
        }
        switch position {
        case .left: leftContainer.addArrangedSubview(view)
        case .right: rightContainer.addArrangedSubview(view)
        default: break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navbarContainer)
        navbarContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        navbarContainer.tintColor = .white

        navbarContainer.addSubview(leftContainer)
        navbarContainer.addSubview(rightContainer)
        navbarContainer.addSubview(titleContainer)

        setupContainers()

        if let navigation = navigationController,
            navigation.viewControllers.count > 1 {
            let button = UIButton(type: .system)
            button.setImage(Asset.arrowLeft.image, for: .normal)
            button.rx.tap
                .bind { navigation.popViewController(animated: true) }
                .disposed(by: disposeBag)
            addButton(button, position: .left)
        }

        addChild(rootViewController)
        view.insertSubview(rootViewController.view, at: 0)
        rootViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        applyContainerStyle(Styles.Generic.navigationBar)
//        updateCurrentNavbarAlpha(1)
        view.layoutIfNeeded()

        Observable.merge(
            rootViewController.navigationItem.rx.observeWeakly(String.self, "title"),
            rootViewController.rx.observeWeakly(String.self, "title")
        )
        .debug()
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: nil)
        .drive(onNext: { [weak self] title in
            self?.setTitle(title ?? "")
        })
        .disposed(by: disposeBag)
    }

    private func setupContainers() {
        titleContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(navbarContainer.safeAreaLayoutGuide.snp.top)
            self.heightConstraint = make.height
                .greaterThanOrEqualTo(navigationBarMinHeight)
                .constraint
                .layoutConstraints
                .first
        }
        titleContainer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftContainer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightContainer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        leftContainer.snp.makeConstraints { make in
            make.centerY.equalTo(titleContainer.snp.centerY)
            make.right.equalTo(titleContainer.snp.left).offset(8)
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
        }
        rightContainer.snp.makeConstraints { make in
            make.centerY.equalTo(titleContainer.snp.centerY)
            make.left.equalTo(titleContainer.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }

    private func clearTitleContainer() {
        titleContainer.subviews.forEach { $0.removeFromSuperview() }
    }

    private func createTitleLabel() {
        clearTitleContainer()
        let title = UILabel()
        titleContainer.addSubview(title)
        currentTitleView = title
        title.applyStyle(Styles.Generic.navigationBar)
        title.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    public func setTitle(_ title: String) {
        guard let label = currentTitleView as? UILabel else {
            createTitleLabel()
            setTitle(title)
            return
        }
        label.styledText = title
    }

    public func setTitleView(_ view: UIView?) {
        clearTitleContainer()
        if let view = view {
            currentTitleView = view
            titleContainer.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().inset(8)
                make.left.greaterThanOrEqualToSuperview()
                make.right.lessThanOrEqualToSuperview()
                make.centerX.equalToSuperview()
            }
        }
    }

    private func adjustInnerSafeAreaInsets() {
        rootViewController.additionalSafeAreaInsets.top = [titleContainer, leftContainer, rightContainer]
            .filter { _ in self.extendUnderNavbar == false }
            .map { $0.bounds.height }
            .sorted(by: >)
            .first ?? 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustInnerSafeAreaInsets()
    }

    func updateCurrentNavbarAlpha(_ value: CGFloat) {
        let value = max(0, min(1, value))
        updateNavbarAlpha(value)
    }

    func updateCurrentNavbarHeight(_ value: CGFloat) {
        let value = max(0, value)
        navigationBarMinHeight = 64 + value
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        rootViewController.preferredStatusBarStyle
    }
}

extension Reactive where Base: NavigationContainer {
    func updateCurrentNavbarAlpha() -> Binder<CGFloat> {
        return Binder(base) { $0.updateCurrentNavbarAlpha($1) }
    }

    func updateCurrentNavbarHeight() -> Binder<CGFloat> {
        return Binder(base) { $0.updateCurrentNavbarHeight($1) }
    }
}

extension UIViewController {
    var container: NavigationContainer? {
        return (self as? NavigationContainer) ?? parent?.container
    }

    func inContainer(extendUnderNavbar: Bool = false) -> NavigationContainer {
        return NavigationContainer(rootViewController: self,
                                   extendUnderNavbar: extendUnderNavbar)
    }

    func setNavigationTitle(_ title: String) {
        container?.setTitle(title)
    }

    func setNavigationView(_ view: UIView) {
        container?.setTitleView(view)
    }

    func addLeftNavigationView(_ view: UIView) {
        container?.addButton(view, position: .left)
    }

    func addRightNavigationView(_ view: UIView) {
        container?.addButton(view, position: .right)
    }
}
