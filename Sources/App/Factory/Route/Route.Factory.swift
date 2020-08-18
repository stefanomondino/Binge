//
//  RouteFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 07/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import UIKit

protocol RouteFactory {
    func restart() -> Route
    func page(from viewModel: ViewModel) -> Route
    func home() -> Route
    func url(for url: URL) -> Route
    func exit() -> CompletableRoute
    func showDetail(for show: ItemContainer) -> Route
    func personDetail(for person: Person) -> Route
    func seasonDetail(for season: Season.Info, of show: ShowItem) -> Route
    func search() -> Route
}
