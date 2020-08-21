//
//  Placeholders.swift
//  Binge
//
//  Created by Stefano Mondino on 19/08/2020.
//

import Foundation

enum Placeholder: String, WithImage {
    var rectangle: Image {
        switch self {
        case .episode: return UIImage.rectangle(rect: CGRect(x: 0, y: 0, width: 320, height: 180), fillColor: .background)
        case .show, .movie, .season: return UIImage.rectangle(rect: CGRect(x: 0, y: 0, width: 250, height: 375), fillColor: .clear)
        default: return UIImage.rectangle(rect: CGRect(x: 0, y: 0, width: 200, height: 200), fillColor: .background)
        }
    }

    var image: Image {
        rectangle
            .overlaying(asset.tinted(with: .mainText))
    }

    func getImage(with _: WithImage?) -> ObservableImage {
        image.getImage()
    }

    private var asset: Image {
        switch self {
        case .person: return Asset.users.image
        case .show: return Asset.photo.image
        case .movie: return Asset.movie.image
        case .season: return Asset.photo.image
        case .episode: return Asset.photo.image
        }
    }

    case person
    case show
    case movie
    case season
    case episode
}
