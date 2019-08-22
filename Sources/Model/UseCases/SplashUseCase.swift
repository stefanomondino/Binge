//
//  SplashUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol SplashUseCaseType {
    func start() -> Observable<()>
}

public struct SplashUseCase: SplashUseCaseType {
    var repository = Repositories.main
    public func start() -> Observable<()> {
        Logger.log("Starting Splash UseCase", level: .verbose)
        return .just(())
    }
}
