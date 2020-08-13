//
//  ShowDetailLayout.swift
//  Binge
//
//  Created by Stefano Mondino on 12/08/2020.
//

import Foundation
import PluginLayout
import UIKit

class ShadowView: UICollectionReusableView {
    static let identifier = "shadow"
    let gradientLayer = CAGradientLayer()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
        backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            layer.addSublayer(gradientLayer)
            gradientLayer.colors = [UIColor.black, UIColor.clear, UIColor.black].map { $0.cgColor }
            gradientLayer.locations = [0, 0.5, 1]
            gradientLayer.startPoint = CGPoint.zero
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.opacity = 0.5
            gradientLayer.actions = [
                "onOrderIn": NSNull(),
                "onOrderOut": NSNull(),
                "sublayers": NSNull(),
                "contents": NSNull(),
                "bounds": NSNull(),
                "frame": NSNull(),
                "position": NSNull()
            ]
        }
        gradientLayer.frame = bounds
    }
}

class ShowHeaderPlugin: Plugin {
    required init(delegate: FlowLayoutDelegate) {
        self.delegate = delegate
    }

    var sectionHeadersPinToVisibleBounds: Bool = false

    var sectionFootersPinToVisibleBounds: Bool = false

    public typealias Delegate = FlowLayoutDelegate
    public typealias Parameters = FlowSectionParameters

    weak var delegate: Delegate?

    func layoutAttributes(in section: Int, offset: inout CGPoint, layout: PluginLayout) -> [PluginLayoutAttributes] {
        guard let collectionView = layout.collectionView else { return [] }
        layout.register(ShadowView.self, forDecorationViewOfKind: ShadowView.identifier)
        let params = sectionParameters(inSection: section, layout: layout)
        let indexPath = IndexPath(item: 0, section: 0)
        let size = delegate?.collectionView?(collectionView, layout: layout, sizeForItemAt: indexPath) ?? .zero
        guard size.width > 0, size.height > 0 else { return [] }
        let poster = PluginLayoutAttributes(forCellWith: indexPath)
        offset.x = params.insets.left
        let width = size.width
        let height = size.height
        let backdropHeight = (delegate as? CollectionViewDelegate)?.sizeCalculator
            .sizeForItem(at: indexPath, in: collectionView, direction: .vertical, type: ViewIdentifier.Supplementary.parallax.identifierString).height ?? 100
        offset.y += backdropHeight - height + height / 3.0

        poster.frame = CGRect(x: offset.x + 20, y: offset.y, width: width - 40, height: height)
        poster.zIndex = 2
        offset.y += poster.frame.height + 20
        let parallax = PluginLayoutAttributes(forSupplementaryViewOfKind: ViewIdentifier.Supplementary.parallax.identifierString, with: IndexPath(item: 0, section: 0))
        parallax.frame = CGRect(x: 0, y: 0, width: params.contentBounds.width, height: backdropHeight)
        parallax.zIndex = 0

        let shadow = PluginLayoutAttributes(forDecorationViewOfKind: ShadowView.identifier, with: indexPath)
        shadow.zIndex = 1
        shadow.frame = parallax.frame

        return [poster, parallax, shadow]
    }
}

class ZoomEffect: PluginEffect {
    var parallax: CGFloat
    init(parallax: CGFloat = 1.0) {
        self.parallax = parallax
    }

    func apply(to originalAttribute: PluginLayoutAttributes,
               layout: PluginLayout,
               plugin _: PluginType,
               sectionAttributes attributes: [PluginLayoutAttributes]) -> PluginLayoutAttributes {
        guard let attribute = originalAttribute.copy() as? PluginLayoutAttributes,
            let collectionOffset = layout.collectionView?.contentOffset.y else { return originalAttribute }
        let offset = parallax * collectionOffset
        var frame = attribute.frame
        if offset < 0 {
            frame.origin.y = collectionOffset
            frame.origin.x = offset / 2
            frame.size.height += -offset
            frame.size.width += -offset
        } else {
            frame.origin.y -= offset - collectionOffset
        }
        if let decoration = attributes
            .filter({ $0.representedElementCategory == .decorationView &&
                    $0.representedElementKind == ShadowView.identifier })
            .first {
            decoration.frame = frame
        }

        attribute.frame = frame
        return attribute
    }
}
