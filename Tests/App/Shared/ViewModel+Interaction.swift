//
//  ViewModel+Interaction.swift
//  SynIt
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import ViewModel
import RxSwift
import Boomerang

extension ViewModel.InteractionViewModelType {
    
    var interaction: Observable<Interaction> {
        return selection.elements.take(1)
    }
    
    var nextRoute: Observable<Any> {
        return selection.elements.take(1).flatMap { i -> Observable<Any> in
            switch i {
            case .route(let route) : return .just(route)
            default: return .empty()
            }
        }
    }
}


func delayed(_ closure: @escaping () -> ()) {
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        closure()
    }
}
