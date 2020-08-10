//
//  SplashUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol SplashUseCase {
    func start() -> Observable<Void>
}
