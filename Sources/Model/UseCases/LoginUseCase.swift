//
//  LoginUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
public protocol LoginUseCase {
    func webViewURL() -> URL?
    func login() -> Observable<()>
}

public struct DefaultLoginUseCase: LoginUseCase {
    
    let authorization: AuthorizationRepository
    
    public func webViewURL() -> URL? {
        return authorization.webViewURL()
    }
    public func login() -> Observable<()> {
        return authorization.token()
    }
}
