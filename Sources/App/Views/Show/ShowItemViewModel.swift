//
//  ShowItemViewModel.swift
//  App
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model

class ShowItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier { show.uniqueIdentifier }
    let show: Show
    let image: ObservableImage
    let styleFactory: StyleFactory
    var title: String {
        return show.title
    }
    init(show: Show,
         layoutIdentifier: LayoutIdentifier,
         imageUseCase: ImagesUseCase,
         styleFactory: StyleFactory) {
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        self.show = show
        
        self.image = imageUseCase
            .poster(forShow: show)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
            .startWith(UIImage())
        
    }
}

