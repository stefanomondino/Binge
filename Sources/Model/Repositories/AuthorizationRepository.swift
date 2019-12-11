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
    func token() -> Observable<()>
    func onAuthorizationURL(url: URL)
    func webViewURL() -> URL?
}

class DefaultAuthorizationRepository: AuthorizationRepository {
    private let authorizationCode = PublishRelay<String>()
    let dataSource: RESTDataSource
    
    init(dataSource: RESTDataSource) {
        self.dataSource = dataSource
    }
    
    func token() -> Observable<()> {
        authorizationCode
            .take(1)
            .flatMapLatest { code in
            return self.dataSource.get(AccessToken.self, at: TraktvAPI.token(code: code))
        }
        .do(onNext: { AccessToken.current = $0 })
            .map { _ in }
    }
    
    func onAuthorizationURL(url: URL) {
        //synit://auth?code=918d022f0ebd037acec31bed26f95394b4940d77a4898cb5480720a15d602b86
        if url.absoluteString.starts(with:  Configuration.environment.traktRedirectURI),
            let code = url.query?
                .components(separatedBy: "&")
                .first(where: { $0.starts(with: "code=")})?
                .dropFirst("code=".count) {
            let authorizationCode = String(code)
            self.authorizationCode.accept(authorizationCode)
        }
        
    }
    func webViewURL() -> URL? {
        return dataSource.request(for: TraktvAPI.authorize)?.url
    }
}
