//
//  PersonDetailUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

struct PersonDetailUseCaseImplementation: PersonDetailUseCase {

    let shows: ShowsRepository
    
     func personDetail(for person: Person) -> Observable<PersonInfo> {
        return shows.info(forPerson: person)
    }
}
