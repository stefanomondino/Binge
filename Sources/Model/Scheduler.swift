//
//  Scheduler.swift
//  Model
//
//  Created by Stefano Mondino on 06/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

struct Scheduler {
    static let background = SerialDispatchQueueScheduler(qos: .utility)
    static let main = MainScheduler.instance
}
