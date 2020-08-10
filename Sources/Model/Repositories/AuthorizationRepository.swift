//
//  AuthorizationRepository.swift
//  Model
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol AuthorizationRepository {
    func login(username: String, password: String) -> Observable<AccessToken>
}

class DefaultAuthorizationRepository: AuthorizationRepository {
    let dataSource: RESTDataSource

    init(dataSource: RESTDataSource) {
        self.dataSource = dataSource
    }

    func login(username: String, password: String) -> Observable<AccessToken> {
        .empty()
//        dataSource.get(AccessToken.self, at: APIProvider.login(username: username, password: password))
//            .do(onNext: { AccessToken.current = $0 })
    }
}
