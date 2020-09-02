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
    func showsHistory() -> Observable<[Trakt.UserWatched]>
    func genresStats() -> Observable<[Trakt.UserGenresStats]>
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
        rest.get(User.Settings.self, at: Trakt.API.userSettings)
    }

    func showsHistory() -> Observable<[Trakt.UserWatched]> {
        userSettings().flatMapLatest { user in
            self.rest
                .get([Trakt.UserWatched].self, at: Trakt.API.userShowHistory(user.user))
                .map { $0 }
        }
    }

    func genresStats() -> Observable<[Trakt.UserGenresStats]> {
        userSettings().flatMapLatest { user in
            self.rest
                .get([Trakt.UserGenresStats].self, at: Trakt.API.userGenres(user.user))
                .map { $0 }
        }
    }
}
