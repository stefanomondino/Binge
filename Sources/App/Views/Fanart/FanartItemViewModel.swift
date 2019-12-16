//
//  FanartViewModel.swift
//  App
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxRelay

class FanartItemViewModel: ViewModel {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier {
        return fanart.id
    }
    let fanart: Fanart
    let image: ObservableImage
    let styleFactory: StyleFactory
    var ratio: CGFloat {
        return fanart.format.ratio
    }
    init(fanart: Fanart,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.fanart,
         styleFactory: StyleFactory) {
         
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        
        self.fanart = fanart
        
        self.image = fanart.getImage()
    }
}
