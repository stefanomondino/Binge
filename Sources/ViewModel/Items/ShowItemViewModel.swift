//
//  ShowItemViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift

/**
    A Boomerang ItemViewModel for Show entity contents.

    Should convert provided entity in order to implement presentation business logic and exposing ready-to-be-displayed values to bounded views.
*/
public class ShowItemViewModel: ItemViewModelType {
    public let identifier: Identifier = Identifiers.Views.show
    
    ///Example title property. Remove if not needed
    public let title: String
    public let poster: ObservableImage
    public let counter: String?
    
    let show: Show
    
    init(trending: TrendingShow) {
        self.show = trending.show
        self.title = show.title
        self.counter = "\(trending.watchers)"
        poster = UseCases.images
            .poster(forShow: show)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
    }
}
