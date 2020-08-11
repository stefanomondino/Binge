//
//  ShowItemViewModel.swift
//  App
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model

enum ShowIdentifier: String, LayoutIdentifier, CaseIterable {
    case posterOnly
    case title
    case full

    var identifierString: String {
        switch self {
        case .posterOnly: return "PosterShow"
        case .full: return "CompleteShow"
        default: return "Show"
        }
    }
}

class ShowItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier { show.uniqueIdentifier }
    let show: Show
    let image: ObservableImage
    let counter: String
    var title: String {
        return show.title
    }

//    static func preview(_ layout: ShowIdentifier) -> ViewModel {
//        ShowItemViewModel(show: TrendingShow.demo.show, layoutIdentifier: layout, imageUseCase: StaticImageUseCase(), styleFactory: DefaultAppDependencyContainer().styleFactory)
//    }
    init(show: Show,
         layoutIdentifier: ShowIdentifier,
         imageUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        self.show = show
        if let year = show.year { counter = "\(year)" } else { counter = "" }
        image = imageUseCase
            .poster(forShow: show)
            .flatMapLatest { $0.getImage() }
//            .share(replay: 1, scope: .forever)
            .startWith(UIImage())
    }
}
