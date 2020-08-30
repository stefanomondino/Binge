//
//  Person.swift
//  Model
//
//  Created by Stefano Mondino on 10/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public extension Trakt {
    struct PeopleResult: Codable {
        let cast: [CastMember]
    }

    struct Person: Codable, TraktItemContainer, TraktItem {
        public var title: String { name }
        public var year: Int? { nil }
        public var item: TraktItem { self }
        public let name: String
//        public let profiles: [Image]?
        public let ids: Trakt.Ids

        public var uniqueIdentifier: String {
            "\(ids.trakt)"
        }
    }

    struct CastMember: Codable, TraktItemContainer {
        public let person: Person
        public let characters: [String]
        public let episodeCount: Int?
        public var item: TraktItem { person }
    }
}

public extension TMDB {
    enum Person {}
}

extension TMDB.Person {
    public struct Info: Codable {
        public struct Image: Codable, DownloadableImage {
            public let aspectRatio: Double
            let filePath: String?
            public var defaultImage: String? { filePath }
            public var allowedSizes: KeyPath<TMDB.Image, [String]> { \.profileSizes }
            public var uniqueIdentifier: String { filePath ?? UUID().uuidString }
        }

        public struct Images: Codable {
            public let profiles: [Image]?
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
}
