//
//  UIViewController+KeyboardAvoid.swift
//  App
//
//  Created by Stefano Mondino on 16/10/2018.
//  Copyright © 2018 Synesthesia. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import pop
import Boomerang

protocol KeyboardAvoidable: UIViewController, ViewModelCompatibleType {
    var keyboardAvoidingView: UIView { get }
    var paddingForAvoidingView: CGFloat { get }
    var bottomConstraint: NSLayoutConstraint? { get }
    func setupKeyboardAvoiding()
}
private struct AssociatedKeys {
    static var typist = "keyboardAvoidable.typist"
}
extension KeyboardAvoidable {
    
    var bottomConstraint: NSLayoutConstraint? {
        return self.keyboardAvoidingView.superview?.constraints.filter {
            ($0.firstAttribute == .bottom && ($0.firstItem as? UIView) == self.keyboardAvoidingView) || ($0.secondAttribute == .bottom && ($0.secondItem as? UIView) == self.keyboardAvoidingView)
        }.first
    }
    private var typist: Typist {
            guard let lookup = objc_getAssociatedObject(self, &AssociatedKeys.typist) as? Typist else {
                let typist = Typist()
                objc_setAssociatedObject(self, &AssociatedKeys.typist, typist, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return typist
            }
            return lookup
    }
    var paddingForAvoidingView: CGFloat {
        return 0
    }
    var direction: CGFloat {
        return ((self.bottomConstraint?.firstItem as? UIView) == self.keyboardAvoidingView) ? -1 : 1
    }
    func setupKeyboardAvoiding() {
        let vc = self as UIViewController
        var originalValue = (self.bottomConstraint?.constant ?? 0) * self.direction
        
        vc.rx.viewWillDisappear()
        .subscribe(onNext: { [weak vc] _ in
            vc?.view.endEditing(true)
        })
        .disposed(by: disposeBag)
        
        vc.rx
            .viewWillAppear()
            .enumerated()
            .flatMapLatest {[weak self] tuple -> Observable<Typist.KeyboardOptions> in
                
                guard let self = self else { return .empty() }
                if tuple.index == 0 {
                    originalValue = (self.bottomConstraint?.constant ?? 0) * self.direction
                }
                return self.typist.rx.keyboardFrameOptions().takeUntil(self.rx.viewDisappear())
            }
            .subscribe(onNext: { [weak self] options in
                guard let self = self else { return }
                let optionBottom = options.bottomValue == 0 ? 0 : options.bottomValue + self.paddingForAvoidingView
                let value = originalValue + optionBottom
                
                let animation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                
                animation?.toValue = value == originalValue ? originalValue : self.direction * abs(value)
                animation?.duration = options.animationDuration
                animation?.timingFunction = CAMediaTimingFunction(name: options.animationCurve.timingFunctionName)
                self.bottomConstraint?.pop_removeAnimation(forKey: "bottomKeyboard")
                self.bottomConstraint?.pop_add(animation, forKey: "bottomKeyboard")

            })
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: Typist {
    func keyboardFrameOptions() -> Observable<Typist.KeyboardOptions> {
        return Observable.create({[weak base] (obs) -> Disposable in
            base?.on(event: .willHide) {
                    obs.onNext($0)
                }.on(event: .didHide) {
                    obs.onNext($0)
                }.on(event: .willShow) {
                    obs.onNext($0)
                }.on(event: .didShow) {
                    obs.onNext($0)
                }.on(event: .willChangeFrame) {
                    obs.onNext($0)
                }.on(event: .didChangeFrame) {
                    obs.onNext($0)
            }.start()
            return Disposables.create()
        })
    }
}

extension UIView.AnimationCurve {
    var timingFunctionName: CAMediaTimingFunctionName {
        switch self {
        case .easeIn: return .easeIn
        case .easeOut : return .easeOut
        case .easeInOut : return CAMediaTimingFunctionName.easeInEaseOut
//        case .linear: return .linear
        default: return .linear
        }
    }
}

extension Typist.KeyboardOptions {
    var bottomValue: CGFloat {
        return ((UIApplication.shared.delegate?.window??.bounds.height ?? 0) - self.endFrame.origin.y)
    }
}
