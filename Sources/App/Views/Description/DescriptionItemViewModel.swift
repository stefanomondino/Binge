//
//  FanartViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class DescriptionItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID().uuidString
    let description: String
    init(description: String,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.description) {
        self.layoutIdentifier = layoutIdentifier
        self.description = description
    }
}
