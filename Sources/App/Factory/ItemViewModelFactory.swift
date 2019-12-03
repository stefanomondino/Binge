//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxRelay

protocol ItemViewModelFactory {
    //    func header(title: String) -> ViewModel
    func show(_ show: WithShow) -> ViewModel
    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel
    
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: AppDependencyContainer
    
    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel {
        LoadMoreItemViewModel(closure)
    }
    
    func show(_ show: WithShow) -> ViewModel {
        ShowItemViewModel(show: show.show,
                          layoutIdentifier: ViewIdentifier.show,
                          imageUseCase: container.model.useCases.images,
                          styleFactory: container.styleFactory
        )
    }
}
