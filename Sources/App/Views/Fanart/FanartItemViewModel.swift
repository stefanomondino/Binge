//
//  FanartViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class FanartItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier {
        return fanart.id
    }

    let fanart: Fanart
    let image: ObservableImage
    let styleFactory: StyleFactory
    var ratio: CGFloat {
        return CGFloat(fanart.format.ratio)
    }

    init(fanart: Fanart,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.fanart,
         styleFactory: StyleFactory) {
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory

        self.fanart = fanart

        image = fanart.getImage()
    }
}
