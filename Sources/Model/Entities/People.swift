//
//  Person.swift
//  Model
//
//  Created by Stefano Mondino on 10/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

struct PeopleResult: Codable {
    let cast: [CastMember]
}

public struct Person: Codable, ItemContainer, Item {
    public struct Image: Codable, DownloadableImage {
        public let aspectRatio: Double
        let filePath: String?
        public var defaultImage: String? { filePath }
        public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.profileSizes }
        public var uniqueIdentifier: String { filePath ?? UUID().uuidString }
    }

    public var title: String { name }
    public var year: Int? { nil }
    public var item: Item { self }
    public let name: String
    public let profiles: [Image]?
    public let ids: Ids
}

public struct CastMember: Codable, ItemContainer {
    public let person: Person
    public let characters: [String]
    let episodeCount: Int?
    public var item: Item { person }
}

public extension Person {
    var uniqueIdentifier: String {
        "\(ids.trakt)"
    }
}

public struct PersonInfo: Codable {
    public struct Images: Codable {
        public let profiles: [Person.Image]?
    }

    public enum Gender: Int, Codable {
        case unknown = 0
        case female = 1
        case male = 2
    }

    public let name: String
    public let profilePath: String?
    public let homepage: String?
    public let placeOfBirth: String?
    public let biography: String
    public let gender: Gender
    public let images: Images?
}
