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
//    let styleFactory: StyleFactory
    var ratio: CGFloat

    init(fanart: Fanart,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.image) {
        self.layoutIdentifier = layoutIdentifier

        ratio = CGFloat(fanart.format.ratio)
        uniqueIdentifier = fanart.id
        image = fanart.getImage()
    }

    init(image: WithImage,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.image,
         ratio: CGFloat = 16 / 9) {
        self.layoutIdentifier = layoutIdentifier
        uniqueIdentifier = UUID()
        self.image = image.getImage()
        self.ratio = ratio
    }

    init(image: DownloadableImage,
         fanart: Fanart?,
         useCase: ImagesUseCase,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.image) {
        self.layoutIdentifier = layoutIdentifier

        ratio = CGFloat(fanart?.format.ratio ?? image.aspectRatio)
        uniqueIdentifier = image.uniqueIdentifier

        self.image = (fanart?.getImage() ?? Observable.just(Image())).flatMap { value -> ObservableImage in
            if value.size.isEmpty {
                return useCase.image(for: image).getImage(with: Placeholder.episode)
            } else {
                return .just(value)
            }
        }
    }
}
