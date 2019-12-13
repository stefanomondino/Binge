//
//  PersonDetailUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol PersonDetailUseCase {
    func personDetail(for person: Person) -> Observable<PersonInfo>
}
struct DefaultPersonDetailUseCase: PersonDetailUseCase {

    let shows: ShowsRepository
    
     func personDetail(for person: Person) -> Observable<PersonInfo> {
        return shows.info(forPerson: person)
    }
}
