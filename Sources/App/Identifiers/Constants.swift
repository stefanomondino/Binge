//
//  Constants.swift
//  Binge
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation

struct Constants {
    static let sidePadding: CGFloat = 16
    static let detailLineSpacing = sidePadding
    static let showPosterRatio: CGFloat = 250.0 / 375.0
    static let episodePosterRatio: CGFloat = 1920 / 1080.0

    static let itemsPerLineClosure: (UICollectionView) -> Int = { collectionView in
        switch collectionView.bounds.width {
        case 0 ... 375: return 3
        case 0 ... 500: return 4
        case 0 ... 768: return 6
        case 0 ... 1024: return 8
        case 0 ... 1200: return 9
        default: return 10
        }
    }
}
