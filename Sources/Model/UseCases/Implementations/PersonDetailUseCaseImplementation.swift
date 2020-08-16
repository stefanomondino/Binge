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

    func personDetail(for person: Person) -> Observable<PersonInfo> {
        return shows.info(forPerson: person)
    }
}

struct MoviePersonDetailUseCaseImplementation: PersonDetailUseCase {
    let movies: MoviesRepository

    func personDetail(for person: Person) -> Observable<PersonInfo> {
        return movies.info(forPerson: person)
    }
}
