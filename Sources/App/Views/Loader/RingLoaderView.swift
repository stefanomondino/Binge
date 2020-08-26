//
//  LoaderView.swift
//  Binge
//
//  Created by Stefano Mondino on 26/08/2020.
//

import RxCocoa
import RxSwift
import UIKit

public class RingLoaderView: UIView {
    private let circle: CAShapeLayer = CAShapeLayer()

    public var speed: Double = 1.0 {
        didSet { animate() }
    }

    public var lineWidth: CGFloat = 4.0 {
        didSet { animate() }
    }

    public var isAnimating: Bool = true {
        didSet { animate() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 50, height: 50)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        layer.addSublayer(circle)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        circle.frame = bounds
        animate()
    }

    private func animate() {
        circle.removeAnimation(forKey: "animation")
        circle.isHidden = !isAnimating

        if isAnimating == false { return }

        let beginTime: Double = 0.5 * speed
        let strokeStartDuration: Double = 1.2 * speed
        let strokeEndDuration: Double = 0.7 * speed

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = -CGFloat.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        rotationAnimation.duration = strokeStartDuration + beginTime

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeEndAnimation, strokeStartAnimation, rotationAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards

        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2),
                                radius: bounds.size.height / 2 - 2,
                                startAngle: 0,
                                endAngle: CGFloat(2.0 * Double.pi),
                                clockwise: false)

        circle.path = path.cgPath
        circle.fillColor = nil
        circle.strokeColor = tintColor.cgColor
        circle.lineWidth = lineWidth
        circle.lineCap = .round
        circle.frame = bounds

        circle.add(groupAnimation, forKey: "animation")
    }
}

extension Reactive where Base: RingLoaderView {
    public var isAnimating: Binder<Bool> {
        Binder(base) { base, value in base.isAnimating = value }
    }
}
