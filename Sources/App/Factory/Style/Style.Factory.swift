//
//  StyleFactory.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import UIKit

protocol StyleFactory {
    func apply(_ style: Style, to view: UIImageView)
    func apply(_ style: Style, to view: UIView)
    func apply(_ style: Style, to view: UILabel)
    func apply(_ style: Style, to view: UIButton)
    func apply(_ style: Style, to view: PagerButton)
    func apply(_ style: Style, to navigationController: NavigationContainer)
}

class DefaultStyleFactory: DependencyContainer {
    static var factory: StyleFactory {
        (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).initializationRoot.styleFactory
    }

    private func register<Value: Any>(for style: Style, scope: Container<DependencyKey>.Scope = .unique, handler: @escaping () -> Value) {
        register(for: style.identifier, scope: scope, handler: handler)
    }

    subscript<T>(index: Style) -> T {
        self[index.identifier]
    }

    var container: Container<String> = Container()

    init(container _: RootContainer) {
        register(for: Styles.Generic.container) { DefaultContainerStyle() }
        register(for: Styles.Generic.title) { DefaultTextStyle(size: 18) }
        register(for: Styles.Generic.subtitle) { DefaultTextStyle(size: 14) }
        register(for: Styles.Generic.card) { DefaultContainerStyle.card }
        register(for: Styles.Generic.navigationBar) { [DefaultContainerStyle(backgroundColor: .orange),
                                                       DefaultTextStyle(size: 22, color: .navbarText, font: .mainBold)] }
    }
}

extension DefaultStyleFactory: StyleFactory {
    private func getStyle<StyleType>(_ style: Style) -> StyleType? {
        if let style: StyleType = resolve(style.identifier) { return style }
        if let styles: [Any] = resolve(style.identifier) {
            return styles.compactMap { $0 as? StyleType }.first
        }
        return nil
    }

    func apply(_: Style, to _: UIImageView) {}

    func apply(_: Style, to _: UIButton) {}

    func apply(_ style: Style, to label: UILabel) {
        guard let implementation: TextStyle = getStyle(style) else { return }
        label.style = implementation.style
        label.numberOfLines = 0
        apply(style, to: label as UIView)
    }

    func apply(_ style: Style, to view: UIView) {
        guard let implementation: ContainerStyle = getStyle(style) else { return }
        view.backgroundColor = implementation.backgroundColor
        view.layer.cornerRadius = implementation.cornerRadius
        view.layer.masksToBounds = true
    }

    func apply(_: Style, to view: PagerButton) {
        view.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        view.tintColor = .darkGray
        //            button.font = Fonts.special(.regular).font(size: 20)
        //            button.font = Fonts.main(.bold).font(size: 16)
        view.selectedTintColor = .black
    }

    func apply(_ style: Style, to navigationController: NavigationContainer) {
        guard let implementation: ContainerStyle = getStyle(style) else { return }
        navigationController.navigationBarColor = implementation.backgroundColor
    }
}

extension NavigationContainer {
    func applyContainerStyle(_ style: Style, factory: StyleFactory = DefaultStyleFactory.factory) {
        factory.apply(style, to: self)
    }
}

extension UIView {
    func applyContainerStyle(_ style: Style, factory: StyleFactory = DefaultStyleFactory.factory) {
        factory.apply(style, to: self)
    }
}

extension UIButton {
    func applyStyle(_ style: Style, factory: StyleFactory = DefaultStyleFactory.factory) {
        factory.apply(style, to: self)
    }
}

extension UILabel {
    func applyStyle(_ style: Style, factory: StyleFactory = DefaultStyleFactory.factory) {
        factory.apply(style, to: self)
    }
}

extension UIImageView {
    func applyStyle(_ style: Style, factory: StyleFactory = DefaultStyleFactory.factory) {
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
            ForEach(Styles.allCases, id: \.identifier) { id in

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
