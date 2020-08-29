//
//  StyleFactory.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxSwift
import UIKit
protocol StyleFactory {
    func apply(_ style: Style, to view: UIImageView)
    func apply(_ style: Style, to view: UITextField)
    func apply(_ style: Style, to view: UIView)
    func apply(_ style: Style, to view: UILabel)
    func apply(_ style: Style, to view: UIButton)
    func apply(_ style: Style, to view: PagerButton)
    func apply(_ style: Style, to navigationController: NavigationContainer)
    func apply(_ style: Style, to tabViewController: TabViewController)
}

protocol DefaultStyleFactory: DependencyContainer, StyleFactory where DependencyKey == Style {
    var root: RootContainer { get }
    static var factory: StyleFactory { get }
}

extension DefaultStyleFactory {
    func getStyle<StyleType>(_ style: Style) -> StyleType? {
        if let style: StyleType = resolve(style) { return style }
        if let styles: [Any] = resolve(style) {
            return styles.compactMap { $0 as? StyleType }.first
        }
        return nil
    }

    private var currentThemeDidChange: Observable<Void> {
        root.model.useCases.themes.currentTheme()
            .map { _ in }
            .observeOn(MainScheduler.instance)
    }

    func apply(_: Style, to _: UIImageView) {}

    func apply(_: Style, to _: UIButton) {}

    func apply(_ style: Style, to label: UILabel) {
        currentThemeDidChange.styling { [weak label] in
            guard let label = label, let implementation: TextStyle = self.getStyle(style) else { return }
            label.style = implementation.style
            label.numberOfLines = 0
//            self.apply(style, to: label as UIView)
            label.backgroundColor = .clear
        }.disposed(by: label.styleDisposeBag)
    }

    func apply(_ style: Style, to textField: UITextField) {
        currentThemeDidChange.styling { [weak textField] in
            guard let textField = textField,
                let implementation: TextStyle = self.getStyle(style) else { return }
            textField.style = implementation.style
            textField.font = implementation.style.attributes[.font] as? UIFont
            textField.leftView = UIView()
                .with(\.backgroundColor, to: .clear)
                .with(\.frame, to: CGRect(x: 0, y: 0, width: Constants.sidePadding, height: 1))
            textField.rightView = UIView()
                .with(\.backgroundColor, to: .clear)
                .with(\.frame, to: CGRect(x: 0, y: 0, width: Constants.sidePadding, height: 1))
            textField.leftViewMode = .always
            textField.rightViewMode = .always
            textField.tintColor = implementation.style.attributes[.foregroundColor] as? UIColor ?? .white
            textField.autocorrectionType = .no
            textField.returnKeyType = .search
            self.apply(style, to: textField as UIView)
        }.disposed(by: textField.styleDisposeBag)
    }

    func apply(_ style: Style, to view: UIView) {
        currentThemeDidChange.styling { [weak view] in
            guard let view = view,
                let implementation: ContainerStyle = self.getStyle(style) else { return }
            view.backgroundColor = implementation.backgroundColor
            view.layer.cornerRadius = implementation.cornerRadius
            view.layer.masksToBounds = true
        }
        .disposed(by: view.styleDisposeBag)
    }

    func apply(_ style: Style, to navigationController: NavigationContainer) {
        currentThemeDidChange.styling { [weak navigationController] in
            guard let implementation: ContainerStyle = self.getStyle(style) else { return }
            navigationController?.navigationBarColor = implementation.backgroundColor
        }.disposed(by: navigationController.disposeBag)
    }

    func apply(_ style: Style, to tabViewController: TabViewController) {
        currentThemeDidChange.styling { [weak tabViewController] in
            guard let tabViewController = tabViewController,
                let implementation: ContainerStyle = self.getStyle(style) else { return }

            tabViewController.tabBar.barTintColor = implementation.backgroundColor
            guard let text: TextStyle = self.getStyle(style) else { return }
            tabViewController.tabBar.isTranslucent = false
            tabViewController.tabBar.tintColor = text.style.attributes[.foregroundColor] as? UIColor ?? .clear
            #if os(iOS)
                tabViewController.statusBarStyle = .lightContent
            #endif
            //        UITabBarItem.appearance().setTitleTextAttributes(text.style.attributes, for: .normal)
        }.disposed(by: tabViewController.disposeBag)
    }
}

extension NavigationContainer {
    func applyContainerStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

extension TabViewController {
    func applyContainerStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

extension UIView {
    func applyContainerStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

extension UIButton {
    func applyStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

extension UILabel {
    func applyStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

extension UITextField {
    func applyStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

extension UIImageView {
    func applyStyle(_ style: Style, factory: StyleFactory = StyleFactoryAlias.factory) {
        factory.apply(style, to: self)
    }
}

#if canImport(SwiftUI) && DEBUG
    import Model
    import SwiftUI
    @available(iOS 13.0, *)

    struct DefaultStyleFactory_Previews: PreviewProvider {
        static var previewContainer = InitializationRoot()
        static var previews: some View {
            ForEach(Style.allCases, id: \.identifier) { id in

                VStack {
                    UIViewPreview {
                        {
                            let label: UILabel = UILabel(frame: .zero)
                            previewContainer.styleFactory.apply(id, to: label)
                            label.styledText = "Style: \(id.identifier)"
                            return label
                        }()
                    }.padding(10)
                }
            }

            .previewLayout(.sizeThatFits)
        }
    }
#endif

extension UIView {
    fileprivate struct AssociatedKeys {
        static var styleDisposeBag = "styleDisposeBag"
    }

    var styleDisposeBag: DisposeBag {
        get {
            guard let disposeBag = objc_getAssociatedObject(self, &AssociatedKeys.styleDisposeBag) as? DisposeBag else {
                let disposeBag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.styleDisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN)
                return disposeBag
            }
            return disposeBag
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.styleDisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension Observable where Element == Void {
    func styling(_ closure: @escaping () -> Void) -> Disposable {
        closure()
        return skip(1).bind {
            UIView.animate(withDuration: 0.25, animations: closure)
        }
    }
}
