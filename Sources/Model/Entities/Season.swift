//
//  Season.swift
//  Model
//
//  Created by Stefano Mondino on 16/08/2020.
//

import Foundation
public enum Season {
    public struct Info: Codable {
        public let id: Int
        public let name: String
        public let episodeCount: Int
        public let overview: String
        public let seasonNumber: Int
        public let posterPath: String?
    }
}

public extension Season.Info {
    var uniqueIdentifier: String {
        "\(id)"
    }
}
