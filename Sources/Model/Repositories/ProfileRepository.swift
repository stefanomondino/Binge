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
    func showsHistory() -> Observable<[UserWatched]>
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

    func showsHistory() -> Observable<[UserWatched]> {
        userSettings().flatMapLatest { user in
            self.rest
                .get([UserWatched].self, at: TraktvAPI.userShowHistory(user.user))
                .map { $0 }
        }
    }
}
