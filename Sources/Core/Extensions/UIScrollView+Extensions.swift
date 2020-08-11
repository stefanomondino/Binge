//
//  UIScrollView+Extensions.swift
//  App
//
//  Created by Stefano Mondino on 19/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension Reactive where Base: UICollectionView {
    func topWindow(of height: CGFloat) -> Observable<CGFloat> {
        return contentOffset
            .map { $0.y / height }
            .observeOn(MainScheduler.asyncInstance)
    }

    func overscroll() -> Observable<CGFloat> {
        return contentOffset.map { max(0, -$0.y) }
    }
}
