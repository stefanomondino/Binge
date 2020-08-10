//
//  Scheduler.swift
//  Model
//
//  Created by Stefano Mondino on 06/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public struct Scheduler {
    public static let background = SerialDispatchQueueScheduler(qos: .utility)
    public static let main = MainScheduler.instance
}
