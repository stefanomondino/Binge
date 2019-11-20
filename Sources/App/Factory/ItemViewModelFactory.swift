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

protocol ItemViewModelFactory {
//    func header(title: String) -> ViewModel
    func show(_ show: Show) -> ViewModel
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: AppDependencyContainer
    func show(_ show: Show) -> ViewModel {
        return ShowItemViewModel(show: show,
                                 layoutIdentifier: ViewIdentifier.show,
                                 imageUseCase: container.model.imagesUseCase
                )
    }
//    func header(title: String) -> ViewModel {
//        return HeaderViewModel(title: title)
//    }
//
//    func episode(_ episode: Episode) -> ViewModel {
//        return ShowViewModel(episode: episode)
//    }
}
