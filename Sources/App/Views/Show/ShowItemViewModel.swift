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
    case person
    case season

    var identifierString: String {
        switch self {
        case .posterOnly: return "PosterShow"
        case .full: return "CompleteShow"
        case .title: return "TitleShow"
        case .person: return "Person"
        case .season: return "Season"
        }
    }

    var style: Style {
        switch self {
        case .title: return Styles.Show.titleCard
        default: return Styles.Generic.card
        }
    }
}

class ShowItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier { item.uniqueIdentifier }
    let item: Item
    let image: ObservableImage
    //    let counter: String
    var title: String {
        return item.title
    }

    var subtitle: String

    let mainStyle: Style
    //    static func preview(_ layout: ShowIdentifier) -> ViewModel {
    //        ShowItemViewModel(show: TrendingShow.demo.show, layoutIdentifier: layout, imageUseCase: StaticImageUseCase(), styleFactory: DefaultAppDependencyContainer().styleFactory)
    //    }
    init(show: ShowItem,
         layoutIdentifier: ShowIdentifier,
         imageUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        item = show.item
        mainStyle = layoutIdentifier.style
        subtitle = show.year?.stringValue ?? ""
        image = imageUseCase
            .poster(for: show)
            .flatMapLatest { $0.getImage() }
            //            .share(replay: 1, scope: .forever)
            .startWith(UIImage())
    }

    init(movie: MovieItem,
         layoutIdentifier: ShowIdentifier,
         imageUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        item = movie.item
        mainStyle = layoutIdentifier.style
        subtitle = ""

        image = imageUseCase
            .poster(for: movie)
            .flatMapLatest { $0.getImage() }
            //            .share(replay: 1, scope: .forever)
            .startWith(UIImage())
    }

    init(person: Person,
         layoutIdentifier: ShowIdentifier = ShowIdentifier.person,
         imagesUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        subtitle = ""
        item = person
        image = imagesUseCase
            .image(forPerson: person)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
    }

    init(castMember: CastMember,
         layoutIdentifier: ShowIdentifier = ShowIdentifier.person,
         imagesUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        item = castMember.person
        subtitle = castMember.characters.joined(separator: ", ")
        image = imagesUseCase
            .image(forPerson: castMember.person)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
    }

    init(season: Season.Info,
         layoutIdentifier: ShowIdentifier = ShowIdentifier.season,
         imagesUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        item = season
        subtitle = "\(season.episodeCount)"
        image = imagesUseCase
            .image(forSeason: season)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
    }

    init(item: Item,
         layoutIdentifier: ShowIdentifier,
         imageUseCase _: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier
        self.item = item
        mainStyle = layoutIdentifier.style
        subtitle = ""
//        if let year = item.year { counter = "\(year)" } else { counter = "" }
        image = .just(UIImage())
    }
}
