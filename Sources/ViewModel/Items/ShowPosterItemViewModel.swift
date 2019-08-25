//
//  ShowPosterItemViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model

/**
    A Boomerang ItemViewModel for ShowPoster entity contents.

    Should convert provided entity in order to implement presentation business logic and exposing ready-to-be-displayed values to bounded views.
*/
public class ShowPosterItemViewModel: ItemViewModelType {
    public let identifier: Identifier = Identifiers.Views.showPoster
    
    ///Example title property. Remove if not needed
    public let title: String
    init(show: ShowDetail) {
        
        self.title = show.title
    }
}
