//
//  FanartViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class ImageItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier

    let image: ObservableImage
    let styleFactory: StyleFactory
    var ratio: CGFloat

    init(fanart: Fanart,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.image,
         styleFactory: StyleFactory) {
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        ratio = CGFloat(fanart.format.ratio)
        uniqueIdentifier = fanart.id
        image = fanart.getImage()
    }

    init(image: Person.Image,
         useCase: ImagesUseCase,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.image,
         styleFactory: StyleFactory) {
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        ratio = CGFloat(image.aspectRatio)
        uniqueIdentifier = image.uniqueIdentifier
        self.image = useCase.image(for: image).flatMap { $0.getImage() }
    }
}
