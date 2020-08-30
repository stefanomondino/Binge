//
//  PersonDetailUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

struct ShowPersonDetailUseCaseImplementation: PersonDetailUseCase {
    let shows: ShowsRepository

    func personDetail(for person: Trakt.Person) -> Observable<TMDB.Person.Info> {
        return shows.info(forPerson: person)
    }

    func cast(for person: Trakt.Person) -> Observable<[TraktItemContainer]> {
        return shows.personCast(for: person).map { $0.cast }
    }
}

struct MoviePersonDetailUseCaseImplementation: PersonDetailUseCase {
    let movies: MoviesRepository

    func personDetail(for person: Trakt.Person) -> Observable<TMDB.Person.Info> {
        return movies.info(forPerson: person)
    }

    func cast(for person: Trakt.Person) -> Observable<[TraktItemContainer]> {
        return movies.personCast(for: person).map { $0.cast }
    }
}
