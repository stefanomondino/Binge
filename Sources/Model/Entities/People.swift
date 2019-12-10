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

public struct Person: Codable {
    public let name: String
    let ids: Ids
}

public struct CastMember: Codable {
    public let person: Person
    public let characters: [String]
    let episodeCount: Int
}
public extension Person {
    var uniqueIdentifier: String {
        "\(ids.trakt)"
    }
}
public struct PersonInfo: Codable {
    let name: String
    let profilePath: String?
}
