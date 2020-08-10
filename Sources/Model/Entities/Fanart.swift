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
    let thetvdbId: String
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

    public func image(for format: Fanart.Format, language: String = "en") -> Fanart? {
        let array: [FanartImage]?
        switch format {
        case .clearLogo: array = clearlogo
        case .thumb: array = tvthumb
        case .hdtvLogo: array = hdtvlogo
        case .clearArt: array = clearart
        case .background: array = showbackground
        case .seasonPoster: array = seasonposter
        case .seasonThumb: array = seasonthumb
        case .hdClearArt: array = hdclearart
        case .tvBanner: array = tvbanner
        case .characterArt: array = characterart
        case .tvPoster: array = tvposter
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

    public enum Format: String, CaseIterable {
        case clearLogo
        case hdtvLogo
        case clearArt
        case background
        case seasonPoster
        case seasonThumb
        case hdClearArt
        case tvBanner
        case characterArt
        case tvPoster
        case thumb
        case seasonBanner
        var ratio: Double {
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
