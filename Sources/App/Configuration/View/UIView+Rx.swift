//
//  UIView+Rx.swift
//  App
//
//  Created by Stefano Mondino on 21/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    
    func layoutSubviews() -> Observable<()> {
        return methodInvoked(#selector(UIView.layoutSubviews)).map {_ in return ()}
    }
    
    func frame() -> Observable<CGRect> {
        return layoutSubviews()
            .map {[weak base] in base?.frame ?? .zero }
            .startWith(base.frame)
            .distinctUntilChanged()
    }
    
    func bounds() -> Observable<CGRect> {
        return layoutSubviews()
            .map {[weak base] in base?.bounds ?? .zero }
            .startWith(base.bounds)
            .distinctUntilChanged()
    }
    var isFirstResponder: Observable<Bool> {
        let on = base.rx.methodInvoked(#selector(UIView.becomeFirstResponder)).map {_ in true}
        let off = base.rx.methodInvoked(#selector(UIView.resignFirstResponder)).map {_ in false }
        return Observable.of(on, off).merge().distinctUntilChanged()
    }
}

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift

extension Reactive where Base: UITabBarItem {
    
    /// Bindable sink for `badgeValue` property.
    func titleText() -> Observable<String?> {
        return methodInvoked(#selector(setter: UITabBarItem.title)).map({ $0.first(where: { $0 is String }) as? String })
    }
    
}

extension Reactive where Base: UIScrollView {
    
    func parallax(amount: CGFloat = 3.0) -> Driver<CGFloat> {
        
        return base.rx.contentOffset
            .asDriver()
            .map { -$0.y / max(1, amount) }
            .map { min(0, $0)}
    }
    
    func bindParallax(top: NSLayoutConstraint, height: NSLayoutConstraint, amount: CGFloat = 3.0) -> Disposable {
        
        let startingHeight = height.constant
        
        let offset = base.rx.contentOffset.asDriver().map { -$0.y }
        // Create two subscriptions for both height and top constraint
        // Returns a composite disposable that will internally dispose both subscriptions
        return Disposables.create(
            parallax(amount: amount).drive(top.rx.constant),
            offset
                .map { max(startingHeight, $0 + startingHeight) }
                .drive(height.rx.constant))
    }
}

#endif
