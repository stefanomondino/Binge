//
//  InteractionViewModelType.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Model

public protocol PageViewModelType: SceneViewModelType {
    var mainTitle: String { get }
    var pageIcon: ObservableImage { get }
}
extension PageViewModelType {
    public var pageIcon: ObservableImage {
        return .empty()
    }
}
