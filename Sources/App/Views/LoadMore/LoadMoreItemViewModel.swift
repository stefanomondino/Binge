//
//  LoadMoreItemViewModel.swift
//  App
//
//  Created by Stefano Mondino on 21/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxSwift

class LoadMoreItemViewModel: ViewModel {
    let uniqueIdentifier: UniqueIdentifier

    let layoutIdentifier: LayoutIdentifier
    let closure: () -> Disposable

    init(uniqueIdentifier: UniqueIdentifier = UUID(), _ closure: @escaping () -> Disposable) {
        layoutIdentifier = ViewIdentifier.loadMore
        self.uniqueIdentifier = uniqueIdentifier
        self.closure = closure
    }

    func reload() -> Disposable {
        closure()
    }
}
