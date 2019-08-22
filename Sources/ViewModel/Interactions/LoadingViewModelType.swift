//
//  LoadingViewModel.swift
//  ViewModel
//
//  Created by Stefano Mondino on 17/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Boomerang

///A view model that keeps count of currently loading processes
public protocol LoadingViewModelType: ViewModelType {
    ///Count of current loading processes. Shouldn't be modified manually, but handled through `bindingLoading(to: LoadingViewModel)` Observable extension.
    var loadingCount: BehaviorRelay<Int> { get }
}

extension LoadingViewModelType {
    ///ViewModel is loading if current loading count is greater than 0
    public var isLoading: Observable<Bool> {
        return loadingCount
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func incrementLoading() {
        loadingCount.accept(loadingCount.value + 1)
    }
    fileprivate func decrementLoading() {
        let currentCount = loadingCount.value
        loadingCount.accept(max(0, currentCount - 1))
    }
}

extension Observable {
    /// Binds a LoadingViewModel to current receiver.
    /// When receiver is subscribed, viewModel's loading count is incremented.
    /// When receiver is disposed, viewModel's loading count is decremented.
    func bindingLoading(to viewModel: LoadingViewModelType) -> Observable<Element> {
        return self.do(
            onSubscribed: { viewModel.incrementLoading() },
            onDispose: { viewModel.decrementLoading() }
        )
    }
}
