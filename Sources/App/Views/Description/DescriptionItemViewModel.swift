//
//  FanartViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class DescriptionItemViewModel: StringViewModel, Hashable {
    static func == (lhs: DescriptionItemViewModel, rhs: DescriptionItemViewModel) -> Bool {
        lhs.uniqueIdentifier.stringValue == rhs.uniqueIdentifier.stringValue && lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
        hasher.combine(uniqueIdentifier.stringValue)
    }

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    let description: String
    init(description: String,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.description,
         uniqueIdentifier: UniqueIdentifier = UUID()) {
        self.layoutIdentifier = layoutIdentifier
        self.uniqueIdentifier = uniqueIdentifier
        self.description = description
    }
}
