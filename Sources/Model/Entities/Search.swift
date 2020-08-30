//
//  Search.swift
//  Binge
//
//  Created by Stefano Mondino on 18/08/2020.
//

import Foundation
extension Trakt {
    public enum Search {
        struct ItemResponse: Codable {
            let movie: Trakt.Movie.Item?
            let show: Trakt.Show.Item?
            let person: Trakt.Person?
            let score: Double
            var item: SearchItem? {
                guard let item: TraktItem = (show ?? movie ?? person) else { return nil }
                return SearchItem(item: item, score: score)
            }
        }

        public struct SearchItem: TraktItemContainer {
            public let item: TraktItem
            public let score: Double
        }
    }
}
