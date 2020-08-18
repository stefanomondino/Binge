//
//  Search.swift
//  Binge
//
//  Created by Stefano Mondino on 18/08/2020.
//

import Foundation

public enum Search {
    struct ItemResponse: Codable {
        let movie: Movie.MovieItemImplementation?
        let show: Show.ShowItemImplementation?
        let person: Person?
        let score: Double
        var item: SearchItem? {
            guard let item: Item = (show ?? movie ?? person) else { return nil }
            return SearchItem(item: item, score: score)
        }
    }

    public struct SearchItem: ItemContainer {
        public let item: Item
        public let score: Double
    }
}
