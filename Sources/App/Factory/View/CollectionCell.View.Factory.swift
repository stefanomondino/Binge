//
//  CollectionViewCellFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import UIKit

class FixedSizeCalculator: AutomaticCollectionViewSizeCalculator {
    let height: CGFloat

    init(viewModel: ListViewModel,
         factory: CollectionViewCellFactory,
         height: CGFloat = 44) {
        self.height = height
        super.init(viewModel: viewModel, factory: factory)
    }

    override func insets(for _: UICollectionView, in _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.sidePadding, left: Constants.sidePadding, bottom: Constants.sidePadding, right: Constants.sidePadding)
    }

    override func itemSpacing(for _: UICollectionView, in _: Int) -> CGFloat {
        Constants.sidePadding
    }

    override func lineSpacing(for _: UICollectionView, in _: Int) -> CGFloat {
        Constants.sidePadding
    }

    override func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView, direction _: Direction?, type: String?) -> CGSize {
        guard viewModel(at: indexPath, for: type) != nil else { return .zero }
        let width = calculateFixedDimension(for: .vertical, collectionView: collectionView, at: indexPath, itemsPerLine: 1)
        return CGSize(width: width, height: height)
    }
}

class MainCollectionViewCellFactory: CollectionViewCellFactory {
    private var viewFactory: ViewFactory

    init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }

    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        return viewFactory.view(from: itemIdentifier)
    }

    func name(from itemIdentifier: LayoutIdentifier) -> String {
        return viewFactory.name(from: itemIdentifier)
    }

    var defaultCellIdentifier: String {
        return "default"
    }

    func cellClass(from _: LayoutIdentifier?) -> UICollectionViewCell.Type {
        return ContentCollectionViewCell.self
    }

    func configureCell(_ cell: UICollectionReusableView, with viewModel: ViewModel) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }
}

#if os(tvOS)
    import ParallaxView

    class ContentCollectionViewCell: ParallaxCollectionViewCell, ContentCollectionViewCellType {
        public func configure(with viewModel: ViewModel) {
            (internalView as? WithViewModel)?.configure(with: viewModel)
        }

        public weak var internalView: UIView? {
            didSet {
                guard let view = internalView else { return }
                backgroundColor = .clear
                contentView.addSubview(view)
                view.snp.makeConstraints { make in
                    self.insetConstraints = make.edges.equalToSuperview().constraint.layoutConstraints
                }
            }
        }

        /// Constraints between cell and inner view.
        public var insetConstraints: [NSLayoutConstraint] = []
        override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
            super.apply(layoutAttributes)
            (internalView as? CollectionViewCellContained)?.apply(layoutAttributes)
        }

        override open var canBecomeFocused: Bool {
            return internalView?.canBecomeFocused ?? super.canBecomeFocused
        }

//        open override var preferredFocusEnvironments: [UIFocusEnvironment] {
//            return internalView?.preferredFocusEnvironments ?? super.preferredFocusEnvironments
//        }
//        open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//            return internalView?.didUpdateFocus(in: context, with: coordinator) ?? super.didUpdateFocus(in: context, with: coordinator)
//        }

        override func setupParallax() {
            cornerRadius = 8

            // Here you can configure custom properties for parallax effect
            parallaxEffectOptions.glowAlpha = 0.4
            parallaxEffectOptions.shadowPanDeviation = 10
            parallaxEffectOptions.parallaxMotionEffect.viewingAngleX = CGFloat(Double.pi / 4 / 30)
            parallaxEffectOptions.parallaxMotionEffect.viewingAngleY = CGFloat(Double.pi / 4 / 30)
            parallaxEffectOptions.parallaxMotionEffect.panValue = CGFloat(10)
            parallaxEffectOptions.glowPosition = .center

            // You can customise parallax view standard behaviours using parallaxViewActions property.
            // Do not forget to use weak self if needed to void retain cycle
            parallaxViewActions.setupUnfocusedState = { (view) -> Void in
                view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

                view.layer.shadowOffset = CGSize(width: 0, height: 3)
                view.layer.shadowOpacity = 0.4
                view.layer.shadowRadius = 5
            }

            parallaxViewActions.setupFocusedState = { (view) -> Void in
                view.transform = CGAffineTransform(scaleX: 1, y: 1)

                view.layer.shadowOffset = CGSize(width: 0, height: 20)
                view.layer.shadowOpacity = 0.4
                view.layer.shadowRadius = 20
            }
            parallaxViewActions.setupUnfocusedState?(self)
        }
    }
#endif
