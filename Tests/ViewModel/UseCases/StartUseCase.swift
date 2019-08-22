//
//  StartUseCase.swift
//  ViewModelTests
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Model

struct MockSplashUseCase: SplashUseCaseType, MockUseCase {
    
    var startObservable: Observable<()> = .empty()
    
    func start() -> Observable<()> {
        return startObservable
    }
}


