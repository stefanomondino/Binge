//
//  PersonViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class SeasonItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier { season.uniqueIdentifier }
    let season: SeasonInfo
    let image: ObservableImage

    var title: String {
        return season.name
    }

    var subtitle: String = ""

    init(season: SeasonInfo,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.season,
         imagesUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier

        self.season = season

        image = imagesUseCase
            .image(forSeason: season)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
    }
}
