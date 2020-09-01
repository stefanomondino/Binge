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
    let item: GenericItem
    let image: ObservableImage
    //    let counter: String
    var title: String {
        return item.title
    }

    var subtitle: String
    var moreText: String?

    let mainStyle: Style

    init(_ show: TraktShowItem,
         layoutIdentifier: Identifier,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = show.item
        mainStyle = layoutIdentifier.style
        subtitle = show.year?.stringValue ?? ""
        image = imagesUseCase
            .poster(for: show)
            .getImage(with: Placeholder.show)
        //            .share(replay: 1, scope: .forever)
    }

    init(_ watched: Trakt.UserWatched,
         layoutIdentifier: Identifier,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = watched.item
        mainStyle = layoutIdentifier.style
        subtitle = "" // show.year?.stringValue ?? ""
        image = imagesUseCase
            .poster(for: watched)
            .getImage(with: Placeholder.show)
        //            .share(replay: 1, scope: .forever)
    }

    init(_ show: Trakt.Show.Cast,
         layoutIdentifier: Identifier,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = show.item
        mainStyle = layoutIdentifier.style
        subtitle = show.characters.joined(separator: ", ")
        if let episodeCount = show.episodeCount {
            moreText = Strings.Shows.episodeCountFormat.format(with: "\(episodeCount)")
        }
        image = imagesUseCase
            .poster(for: show)
            .getImage(with: Placeholder.person.image)
        //            .share(replay: 1, scope: .forever)
    }

    init(_ movie: Trakt.Movie.Cast,
         layoutIdentifier: Identifier,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = movie.item
        mainStyle = layoutIdentifier.style
        subtitle = movie.characters.joined(separator: ", ")
        image = imagesUseCase
            .poster(for: movie)
            .getImage(with: Placeholder.person.image)
        //            .share(replay: 1, scope: .forever)
    }

    init(_ movie: TraktMovieItem,
         layoutIdentifier: Identifier,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        item = movie.item
        mainStyle = layoutIdentifier.style
        subtitle = ""

        image = imagesUseCase
            .poster(for: movie)
            .getImage(with: Placeholder.movie)
        //            .share(replay: 1, scope: .forever)
    }

    convenience init(_ search: Trakt.Search.SearchItem,
                     layoutIdentifier: Identifier,
                     imagesUseCase: ImagesUseCase) {
        switch search.item {
        case let show as TraktShowItem: self.init(show,
                                                  layoutIdentifier: layoutIdentifier,
                                                  imagesUseCase: imagesUseCase)
        case let movie as TraktMovieItem: self.init(movie,
                                                    layoutIdentifier: layoutIdentifier,
                                                    imagesUseCase: imagesUseCase)
        case let person as Trakt.Person: self.init(person,
                                                   layoutIdentifier: layoutIdentifier,
                                                   imagesUseCase: imagesUseCase)
        default: self.init(search.item,
                           layoutIdentifier: layoutIdentifier,
                           imagesUseCase: imagesUseCase)
        }
    }

    init(_ person: Trakt.Person,
         layoutIdentifier: Identifier = .person,
         imagesUseCase: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        mainStyle = layoutIdentifier.style
        subtitle = ""
        item = person
        image = imagesUseCase
            .image(for: person)
            .getImage(with: Placeholder.person)
            .share(replay: 1, scope: .forever)
    }

    init(_ castMember: Trakt.CastMember,
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
            .image(for: castMember.person)
            .getImage(with: Placeholder.person)
            .share(replay: 1, scope: .forever)
    }

    init(_ episode: TMDB.Season.Episode,
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

    init(_ season: TMDB.Season.Info,
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
            .image(for: season)
            .getImage(with: Placeholder.season)
            .share(replay: 1, scope: .forever)
    }

    init(_ item: GenericItem,
         layoutIdentifier: Identifier,
         imagesUseCase _: ImagesUseCase) {
        showIdentifier = layoutIdentifier
        self.item = item
        mainStyle = layoutIdentifier.style
        subtitle = ""
        image = .just(UIImage())
    }
}
