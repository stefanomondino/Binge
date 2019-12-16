//
//  Fanart.swift
//  Model
//
//  Created by Stefano Mondino on 16/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public struct FanartResponse: Codable {
    
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
        
        public var size: CGSize {
            switch self {
            case .clearLogo: return CGSize(width: 400, height: 155)
            case .clearArt: return CGSize(width: 500, height: 281)
            case .hdClearArt: return CGSize(width: 1000, height: 562)
            case .hdtvLogo: return CGSize(width: 800, height: 310)
            case .tvPoster: return CGSize(width: 1000, height: 1426)
            case .seasonPoster: return CGSize(width: 1000, height: 1426)
            case .characterArt: return CGSize(width: 512, height: 512)
            case .seasonThumb: return CGSize(width: 1000, height: 562)
            case .background: return CGSize(width: 1920, height: 1080)
            case .tvBanner: return CGSize(width: 1000, height: 185)
            case .thumb: return CGSize(width: 1000, height: 562)
            case .seasonBanner: return CGSize(width: 1000, height: 185)
            }
        }
    }
    
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
    
    public func image(for format: Format, language: String = "en") -> WithImage? {
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
        return array?.first(where: { $0.lang == language }) ?? array?.first
    }
}

struct FanartImage: Codable {
    let id: String
    let url: String
    let lang: String
    let likes: String
    let season: String?
}

extension FanartImage: WithImage {
    func getImage(with placeholder: WithImage?) -> ObservableImage {
        return url.getImage(with: placeholder)
    }
}
