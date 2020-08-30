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

typealias SettingsListViewModelType = RxListViewModel & WithPage

protocol RouteFactory {
    func restart() -> Route
    func page(from viewModel: ViewModel) -> Route
    func home() -> Route
    func url(for url: URL) -> Route
    func exit() -> CompletableRoute
    func showDetail(for show: TraktItemContainer) -> Route
    func personDetail(for person: Trakt.Person) -> Route
    func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> Route
    func search() -> Route
    func error(_ error: Errors, retry: (() -> Void)?) -> Route
    func settings() -> Route
    func settingsList(viewModel: SettingsListViewModelType) -> Route
}
