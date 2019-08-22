//
//  Interactions.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import Model

public enum InteractionValue: CustomInteraction {
    case start
    case invalidate
    case login
    case observable(Observable<Interaction>)
}

extension InteractionViewModelType {
    public func interact(_ value: InteractionValue) {
        self.interact(Interaction.custom(value))
    }
    
    public var interactionErrors: Observable<Error> {
        return  selection.errors.map {
            switch $0 {
            case.underlyingError(let e): return e
            default: return nil
            }
            }
            .flatMap { Observable.from(optional: $0)}
    }
    public func handleCustom(_ interaction: CustomInteraction) -> Observable<Interaction> {
        guard let interaction = interaction as? InteractionValue else { return .empty() }
        
        switch interaction {
        case .start: return handleStart()
        case .invalidate: return handleStart()
        case .observable(let o): return o
        case .login: return handleLogin()
        }
    }
    public func handleLogin() -> Observable<Interaction> {
        //Insert here custom LoginViewModel() route, see comment below.
        return .empty()
        //return .just(Interaction.route(LoginRoute(viewModel: LoginViewModel())))
        
    }
    public func handleStart() -> Observable<Interaction> {
        return .just(.none)
    }
}

extension InteractionViewModelType {
    func handleErrors(for errors: Observable<Error>) -> Disposable {
        let selection = self.selection
        return errors
            .debug()
            .observeOn(MainScheduler.asyncInstance)
            .map { Interaction.route(ErrorRoute(error: $0)) }
            .do(onNext: { selection.execute($0) })
            .subscribe()
    }
}
