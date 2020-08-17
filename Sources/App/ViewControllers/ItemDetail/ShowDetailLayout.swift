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
        insetsLayoutMarginsFromSafeArea = false
        backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        insetsLayoutMarginsFromSafeArea = false
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

class ShowHeaderPlugin: FlowLayoutPlugin {
    override func layoutAttributes(in section: Int, offset: inout CGPoint, layout: PluginLayout) -> [PluginLayoutAttributes] {
        guard let collectionView = layout.collectionView else { return [] }
        layout.register(ShadowView.self, forDecorationViewOfKind: ShadowView.identifier)
        let params = sectionParameters(inSection: section, layout: layout)
        let indexPath = IndexPath(item: 0, section: 0)
        let size = delegate?.collectionView?(collectionView, layout: layout, sizeForItemAt: indexPath) ?? .zero
        guard size.width > 0, size.height > 0 else { return [] }

        let height = size.height
        let minHeight = params.contentBounds.width / (16 / 9)
        let expectedSize = (delegate as? CollectionViewDelegate)?.sizeCalculator
            .sizeForItem(at: indexPath, in: collectionView, direction: .vertical, type: ViewIdentifier.Supplementary.parallax.identifierString)
            ?? CGSize(width: params.contentBounds.width, height: minHeight)
        var backdropHeight = params.contentBounds.width / (expectedSize.width / expectedSize.height)
        if backdropHeight.isNaN || backdropHeight < minHeight { backdropHeight = minHeight }
        offset.y += backdropHeight - height + height / 3.0

        let attributes = super.layoutAttributes(in: section, offset: &offset, layout: layout)
        attributes.forEach { $0.zIndex = 2 }

        let parallax = PluginLayoutAttributes(forSupplementaryViewOfKind: ViewIdentifier.Supplementary.parallax.identifierString, with: IndexPath(item: 0, section: 0))
        parallax.frame = CGRect(x: 0, y: 0, width: params.contentBounds.width, height: backdropHeight)
        parallax.zIndex = 0

        let shadow = PluginLayoutAttributes(forDecorationViewOfKind: ShadowView.identifier, with: indexPath)
        shadow.zIndex = 1
        shadow.frame = parallax.frame

        return [parallax, shadow] + attributes
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
            attribute.alpha = 1
            frame.origin.y = collectionOffset
            frame.origin.x = offset / 2
            frame.size.height += -offset
            frame.size.width += -offset
        } else {
            frame.origin.y -= offset - collectionOffset
            attribute.alpha = max(0, 1 - 4 * (frame.origin.y / frame.size.height))
        }
        if let decoration = attributes
            .filter({ $0.representedElementCategory == .decorationView &&
                    $0.representedElementKind == ShadowView.identifier })
            .first {
            decoration.frame = frame
            decoration.alpha = attribute.alpha
        }

        attribute.frame = frame
        return attribute
    }
}
