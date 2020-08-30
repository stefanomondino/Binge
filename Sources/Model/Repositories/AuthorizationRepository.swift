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
    func logout() -> Observable<Void>
}

class DefaultAuthorizationRepository: AuthorizationRepository {
    private let authorizationCode = PublishRelay<String>()
    let dataSource: RESTDataSource
    private let isLoggedTrigger: BehaviorRelay<Void> = BehaviorRelay(value: ())
    init(dataSource: RESTDataSource) {
        self.dataSource = dataSource
    }

    private func updateAccessToken(_ token: AccessToken?) {
        AccessToken.current = token
        isLoggedTrigger.accept(())
    }

    func token() -> Observable<Void> {
        authorizationCode
            .take(1)
            .flatMapLatest { code in
                self.dataSource.get(AccessToken.self, at: Trakt.API.token(code: code))
            }
            .do(onNext: { self.updateAccessToken($0) })
            .map { _ in }
    }

    func isLogged() -> Observable<Bool> {
        isLoggedTrigger.map { AccessToken.current != nil }
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
        return dataSource.request(for: Trakt.API.authorize)?.url
    }

    func logout() -> Observable<Void> {
        .deferred {
            guard let token = AccessToken.current?.accessToken else { return .just(()) }
            self.updateAccessToken(nil)
            return self.dataSource
                .get(EmptyResource.self, at: Trakt.API.logout(token: token))
                .map { _ in }
                .catchErrorJustReturn(())
        }
    }
}
