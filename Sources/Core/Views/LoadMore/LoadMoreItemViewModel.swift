//
//  LoadMoreItemViewModel.swift
//  App
//
//  Created by Stefano Mondino on 21/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift

public class LoadMoreItemViewModel: ViewModel {
    public let layoutIdentifier: LayoutIdentifier
    let closure: () -> Disposable
    
    public init(_ closure: @escaping () -> Disposable) {
        self.layoutIdentifier = ViewIdentifier.loadMore
        self.closure = closure
    }
    
    func reload() -> Disposable {
        closure()
    }
}
