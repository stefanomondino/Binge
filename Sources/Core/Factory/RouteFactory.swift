//
//  RouteFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 07/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

public protocol CoreRouteFactory {
    func restartRoute() -> Route
    func homeRoute() -> Route
}
