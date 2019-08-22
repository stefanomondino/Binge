//
//  InteractionViewModelType.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import protocol Boomerang.InteractionViewModelType
import enum Boomerang.Interaction

//Add to this custom protocol each custom interaction handling in order to override it in ViewModel implementations.
//It won't work without "handle" method declaration inside this protocol.
public protocol InteractionViewModelType: Boomerang.InteractionViewModelType {
    func handleStart() -> Observable<Interaction>
    func handleLogin() -> Observable<Interaction>
}
