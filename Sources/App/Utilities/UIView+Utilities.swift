//
//  UIView+Utilities.swift
//  App
//
//  Created by Andrea Lucibello on 17/05/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
import UIKit
import SkeletonView
import Boomerang
import ViewModel
import RxSwift

protocol Skeletonable {
    var skeletonViews: [UIView] { get }
}

extension Skeletonable where Self: UIView, Self: ViewModelCompatibleType {
    
    func bindSkeleton(to viewModel: LoadingViewModelType) -> Disposable {
        return viewModel.isLoading.debug()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] in
                self?.toggleSkeleton($0)
            })
    }
    
    func toggleSkeleton(_ active: Bool) {
        if self.isPlaceholderForAutosize { return }
        skeletonViews.forEach {
            $0.isSkeletonable = true
//            if let label = $0 as? UILabel,
//                (label.styledText?.isEmpty ?? false) {
//                label.styledText = " "
//            }
        }
        
        if active {
            self.layoutIfNeeded()
            self.showAnimatedGradientSkeleton()
        } else {
            self.stopSkeletonAnimation()
            self.hideSkeleton(reloadDataAfter: true)
        }
    }
}
