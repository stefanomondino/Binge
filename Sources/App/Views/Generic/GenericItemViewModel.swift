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
import RxSwift

extension GenericItemViewModel.Identifier {
    var identifierString: String {
        switch self {
        case .posterOnly: return "Poster"
        case .full: return "Complete"
        case .title: return "Title"
        case .person: return "Person"
        case .season: return "Season"
        case .episode: return "Episode"
        }
    }

    var style: Style {
        switch self {
        case .title: return .titleCard
        default: return .card
        }
    }

    var gridCount: Int {
        switch self {
        case .title: return 1
        case .episode: return 2
        default: return 3
        }
    }
}

class GenericItemViewModel: ViewModel {
    enum Identifier: String, LayoutIdentifier, CaseIterable {
        case posterOnly
        case title
        case full
        case person
        case season
        case episode
    }

    var layoutIdentifier: LayoutIdentifier { showIdentifier }
    let showIdentifier: Identifier
    var uniqueIdentifier: UniqueIdentifier { item.uniqueIdentifier }
    let item: Item
    let image: ObservableImage
    //    let counter: String
    var title: String {
        return item.title
    }

    var subtitle: String
    var moreText: String?

    let mainStyle: Style

    init(show: ShowItem,
         layoutIdentifier: Identifier,
         imageUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = show.item
        mainStyle = layoutIdentifier.style
        subtitle = show.year?.stringValue ?? ""
        image = imageUseCase
            .poster(for: show)
            .getImage(with: Placeholder.show)
        //            .share(replay: 1, scope: .forever)
    }

    init(showCast show: Show.Cast,
         layoutIdentifier: Identifier,
         imageUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = show.item
        mainStyle = layoutIdentifier.style
        subtitle = show.characters.joined(separator: ", ")
        if let episodeCount = show.episodeCount {
            moreText = "\(episodeCount)"
        }
        image = imageUseCase
            .poster(for: show)
            .getImage(with: Placeholder.person.image)
        //            .share(replay: 1, scope: .forever)
    }

    init(movieCast movie: Movie.Cast,
         layoutIdentifier: Identifier,
         imageUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = movie.item
        mainStyle = layoutIdentifier.style
        subtitle = movie.characters.joined(separator: ", ")
        image = imageUseCase
            .poster(for: movie)
            .getImage(with: Placeholder.person.image)
        //            .share(replay: 1, scope: .forever)
    }

    init(movie: MovieItem,
         layoutIdentifier: Identifier,
         imageUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = movie.item
        mainStyle = layoutIdentifier.style
        subtitle = ""

        image = imageUseCase
            .poster(for: movie)
            .getImage(with: Placeholder.movie)
        //            .share(replay: 1, scope: .forever)
    }

    convenience init(search: Search.SearchItem,
                     layoutIdentifier: Identifier,
                     imageUseCase: ImagesUseCase) {
        switch search.item {
        case let show as ShowItem: self.init(show: show,
                                             layoutIdentifier: layoutIdentifier,
                                             imageUseCase: imageUseCase)
        case let movie as MovieItem: self.init(movie: movie,
                                               layoutIdentifier: layoutIdentifier,
                                               imageUseCase: imageUseCase)
        case let person as Person: self.init(person: person,
                                             layoutIdentifier: layoutIdentifier,
                                             imagesUseCase: imageUseCase)
        default: self.init(item: search.item,
                           layoutIdentifier: layoutIdentifier,
                           imageUseCase: imageUseCase)
        }
    }

    init(person: Person,
         layoutIdentifier: Identifier = .person,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        subtitle = ""
        item = person
        image = imagesUseCase
            .image(forPerson: person)
            .getImage(with: Placeholder.person)
            .share(replay: 1, scope: .forever)
    }

    init(castMember: CastMember,
         layoutIdentifier: Identifier = .person,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        item = castMember.person
        subtitle = castMember.characters.joined(separator: ", ")
        if let episodeCount = castMember.episodeCount {
            moreText = Strings.Shows.episodeCountFormat.format(with: "\(episodeCount)")
        }
        image = imagesUseCase
            .image(forPerson: castMember.person)
            .getImage(with: Placeholder.person)
            .share(replay: 1, scope: .forever)
    }

    init(season: Season.Info,
         layoutIdentifier: Identifier = .season,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        item = season
        if let episodeCount = season.episodeCount {
            subtitle = Strings.Shows.episodeCountFormat.format(with: "\(episodeCount)")
        } else {
            subtitle = ""
        }
        image = imagesUseCase
            .image(forSeason: season)
            .getImage(with: Placeholder.season)
            .share(replay: 1, scope: .forever)
    }

    init(episode: Season.Episode,
         layoutIdentifier: Identifier = .season,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        item = episode
        if let episodeNumber = episode.episodeNumber {
            subtitle = "#\(episodeNumber)"
        } else {
            subtitle = ""
        }
        image = imagesUseCase
            .image(for: episode)
            .getImage(with: Placeholder.episode)
            .share(replay: 1, scope: .forever)
    }

    init(item: Item,
         layoutIdentifier: Identifier,
         imageUseCase _: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        self.item = item
        mainStyle = layoutIdentifier.style
        subtitle = ""
//        if let year = item.year { counter = "\(year)" } else { counter = "" }
        image = .just(UIImage())
    }
}
