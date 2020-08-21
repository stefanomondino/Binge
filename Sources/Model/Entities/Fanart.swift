//
//  Fanart.swift
//  Model
//
//  Created by Stefano Mondino on 16/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public struct FanartResponse: Codable {
    let name: String
    let thetvdbId: String?
    let tmdbId: String?
    let imdbId: String?
    let clearlogo: [FanartImage]?
    let hdtvlogo: [FanartImage]?
    let clearart: [FanartImage]?
    let showbackground: [FanartImage]?
    let seasonposter: [FanartImage]?
    let seasonthumb: [FanartImage]?
    let hdclearart: [FanartImage]?
    let tvbanner: [FanartImage]?
    let tvthumb: [FanartImage]?
    let characterart: [FanartImage]?
    let tvposter: [FanartImage]?
    let seasonbanner: [FanartImage]?

    let hdmovielogo: [FanartImage]?
    let moviedisc: [FanartImage]?
    let movielogo: [FanartImage]?
    let movieposter: [FanartImage]?
    let hdmovieclearart: [FanartImage]?
    let movieart: [FanartImage]?
    let moviebackground: [FanartImage]?
    let moviebanner: [FanartImage]?
    let moviethumb: [FanartImage]?
    // swiftlint:disable cyclomatic_complexity
    public func showImage(for formats: [Fanart.Format], language: String = "en") -> Fanart? {
        formats.compactMap { showImage(for: $0, language: language) }.first
    }

    public func movieImage(for formats: [Fanart.Format], language: String = "en") -> Fanart? {
        formats.compactMap { movieImage(for: $0, language: language) }.first
    }

    public func showImage(for format: Fanart.Format, language: String = "en") -> Fanart? {
        let array: [FanartImage]?
        switch format {
        case .clearLogo: array = clearlogo
        case .thumb: array = tvthumb
        case .hdtvLogo: array = hdtvlogo
        case .clearArt: array = clearart
        case .background: array = showbackground
        case let .seasonPoster(id): array = seasonposter?.filter { $0.season == id }
        case let .seasonThumb(id): let custom = [showbackground, seasonthumb]
            .compactMap { $0 }
            .flatMap { $0 }
            .filter { $0.season == id || $0.season == nil }
            .sorted(by: \.likes)
            .reversed()
            .map { $0 }

            array = custom.isEmpty ? showbackground : custom

        case .hdClearArt: array = hdclearart
        case .tvBanner: array = tvbanner
        case .characterArt: array = characterart
        case .tvPoster: array = tvposter
        case let .seasonBanner(id): array = seasonbanner?.filter { $0.season == id }
        }
        if let image = array?
            .sorted(by: \.likes)
            .reversed()
            .first(where: { $0.lang == language }) ?? array?.first {
            return Fanart(format: format, image: image)
        } else {
            return nil
        }
    }

    public func movieImage(for format: Fanart.Format, language: String = "en") -> Fanart? {
        let array: [FanartImage]?
        switch format {
        case .clearLogo: array = hdmovielogo
        case .thumb: array = moviethumb
        case .hdtvLogo: array = hdmovielogo
        case .clearArt: array = hdmovieclearart
        case .background: array = moviebackground
        case .seasonPoster: array = movieposter
        case .seasonThumb: array = moviethumb
        case .hdClearArt: array = hdmovieclearart
        case .tvBanner: array = moviebanner
        case .characterArt: array = characterart
        case .tvPoster: array = movieposter
        case .seasonBanner: array = seasonbanner
        }
        if let image = array?.first(where: { $0.lang == language }) ?? array?.first {
            return Fanart(format: format, image: image)
        } else {
            return nil
        }
    }
}

public struct Fanart {
    struct Size {
        let width: Double
        let height: Double
    }

    public enum Format {
        case clearLogo
        case hdtvLogo
        case clearArt
        case background
        case seasonPoster(String)
        case seasonThumb(String)
        case hdClearArt
        case tvBanner
        case characterArt
        case tvPoster
        case thumb
        case seasonBanner(String)
        public var ratio: Double {
            return size.width / size.height
        }

        var size: Size {
            switch self {
            case .clearLogo: return Size(width: 400, height: 155)
            case .clearArt: return Size(width: 500, height: 281)
            case .hdClearArt: return Size(width: 1000, height: 562)
            case .hdtvLogo: return Size(width: 800, height: 310)
            case .tvPoster: return Size(width: 1000, height: 1426)
            case .seasonPoster: return Size(width: 1000, height: 1426)
            case .characterArt: return Size(width: 512, height: 512)
            case .seasonThumb: return Size(width: 1000, height: 562)
            case .background: return Size(width: 1920, height: 1080)
            case .tvBanner: return Size(width: 1000, height: 185)
            case .thumb: return Size(width: 1000, height: 562)
            case .seasonBanner: return Size(width: 1000, height: 185)
            }
        }
    }

    public let format: Fanart.Format
    public var id: String { return image.id }
    let image: FanartImage
}

struct FanartImage: Codable {
    let id: String
    let url: String
    let lang: String
    let likes: String
    let season: String?
}

extension Fanart: WithImage {
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return image.url.getImage(with: placeholder)
    }
}

extension Array {
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }
}
