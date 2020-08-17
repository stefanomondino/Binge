//
//  Season.swift
//  Model
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation
public enum Season {
    public struct Info: Codable, Item {
        public let id: Int
        public let name: String
        public let episodeCount: Int
        public let overview: String
        public let seasonNumber: Int
        public let posterPath: String?
        public var title: String { name }
        public var item: Item { self }
        public var ids: Ids { Ids.empty }
    }
}

public extension Season.Info {
    var uniqueIdentifier: String {
        "\(id)"
    }
}
