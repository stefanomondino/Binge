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
    func token() -> Observable<Void>
    func onAuthorizationURL(url: URL)
    func webViewURL() -> URL?
    func isLogged() -> Observable<Bool>
}

class DefaultAuthorizationRepository: AuthorizationRepository {
    private let authorizationCode = PublishRelay<String>()
    let dataSource: RESTDataSource

    init(dataSource: RESTDataSource) {
        self.dataSource = dataSource
    }

    func token() -> Observable<Void> {
        authorizationCode
            .take(1)
            .flatMapLatest { code in
                self.dataSource.get(AccessToken.self, at: TraktvAPI.token(code: code))
            }
            .do(onNext: { AccessToken.current = $0 })
            .map { _ in }
    }

    func isLogged() -> Observable<Bool> {
        .just(AccessToken.current != nil)
    }

    func onAuthorizationURL(url: URL) {
        if url.absoluteString.starts(with: Configuration.environment.traktRedirectURI),
            let code = url.query?
            .components(separatedBy: "&")
            .first(where: { $0.starts(with: "code=") })?
            .dropFirst("code=".count) {
            authorizationCode.accept(String(code))
        }
    }

    func webViewURL() -> URL? {
        return dataSource.request(for: TraktvAPI.authorize)?.url
    }
}
