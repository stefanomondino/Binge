//
//  Placeholders.swift
//  Binge
//
//  Created by Stefano Mondino on 19/08/2020.
//

import Foundation

enum Placeholder: String, WithImage {
    var rectangle: Image {
        UIImage.rectangle(rect: CGRect(x: 0, y: 0, width: 200, height: 200), fillColor: .background)
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
        case .person: return Asset.heart.image
        case .show: return Asset.heart.image
        case .movie: return Asset.heart.image
        case .season: return Asset.heart.image
        case .episode: return Asset.heart.image
        }
    }

    case person
    case show
    case movie
    case season
    case episode
}
