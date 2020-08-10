//
//  UIKit+Preview.swift
//  App
//
//  Created by Stefano Mondino on 19/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    public struct UIViewPreview<View: UIView>: UIViewRepresentable {
        let view: View

        public init(_ builder: @escaping () -> View) {
            view = builder()
        }

        // MARK: - UIViewRepresentable

        public func makeUIView(context _: Context) -> UIView {
            return view
        }

        public func updateUIView(_ view: UIView, context _: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.setContentHuggingPriority(.required, for: .vertical)
            view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }
    }
#endif

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
        let viewController: ViewController

        public init(_ builder: @escaping () -> ViewController) {
            viewController = builder()
        }

        // MARK: - UIViewControllerRepresentable

        public func makeUIViewController(context _: Context) -> ViewController {
            viewController
        }

        @available(iOS 13.0, *)
        public func updateUIViewController(_: ViewController, context _: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
            return
        }
    }
#endif
