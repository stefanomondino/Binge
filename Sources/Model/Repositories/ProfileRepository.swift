//
//  ProfileRepository.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Foundation
import RxSwift

protocol ProfileRepository {
    func userSettings() -> Observable<User.Settings>
}

class ProfileRepositoryImplementation: ProfileRepository {
    let rest: RESTDataSource
    let authorization: AuthorizationRepository

    init(rest: RESTDataSource,
         authorization: AuthorizationRepository) {
        self.rest = rest
        self.authorization = authorization
    }

    func userSettings() -> Observable<User.Settings> {
        rest.get(User.Settings.self, at: TraktvAPI.userSettings)
    }
}
