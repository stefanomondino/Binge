//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import UIKit

protocol ViewControllerFactory {
    func root() -> UIViewController
    func pager(viewModel: PagerViewModel) -> UIViewController
    func mainTabBar() -> UIViewController
    func user(viewModel: UserViewModel) -> UIViewController
    func showPager() -> UIViewController
    func showList(viewModel: ItemListViewModel) -> UIViewController
    func itemDetail(viewModel: ItemDetailViewModel) -> UIViewController
    func person(viewModel: PersonViewModel) -> UIViewController
    func search(viewModel: SearchViewModel) -> UIViewController
    func settings(viewModel: SettingsViewModel) -> UIViewController
    func settingsList(viewModel: SettingsListViewModelType) -> UIViewController
    // MURRAY DECLARATION PLACEHOLDER
}
