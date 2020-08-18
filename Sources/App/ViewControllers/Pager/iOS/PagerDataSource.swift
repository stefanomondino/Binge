//
//  PagerDataSource.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Pageboy
import Tabman

class PagerDataSource: PageboyViewControllerDataSource, TMBarDataSource {
    let viewModel: ListViewModel
    let factory: RouteFactory

    private var cache: [Int: UIViewController] = [:]
    func clear() {
        cache = [:]
    }

    init(viewModel: ListViewModel, factory: RouteFactory) {
        self.viewModel = viewModel
        self.factory = factory
    }

    private func item(at index: PageboyViewController.PageIndex) -> ViewModel {
        let items = viewModel.sections.flatMap { $0.items }
        return items[index]
    }

    func numberOfViewControllers(in _: PageboyViewController) -> Int {
        return viewModel
            .sections
            .flatMap { $0.items }
            .count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        //        guard let viewModel = self.viewModel.mainViewModel(at: IndexPath(indexes: [index])) as? SceneViewModelType,
        //            let viewController = viewModel.sceneIdentifier.scene() as?  (UIViewController & ViewModelCompatibleType)  else {
        //            return nil
        //        }
        if let cached = cache[index] {
            return cached
        }
        guard let viewController = factory
            .page(from: item(at: index))
            .createScene() as? UIViewController else { return nil }

        if #available(iOS 11.0, *) {
            var insets = viewController.additionalSafeAreaInsets
            insets.top += ((pageboyViewController as? TabmanViewController)?.barInsets ?? .zero).top
            viewController.additionalSafeAreaInsets = insets
        } else {
            // Fallback on earlier versions
        }
        cache[index] = viewController
        return viewController
    }

    func defaultPage(for _: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }

    func barItem(for _: TMBar, at index: Int) -> TMBarItemable {
        let title = (item(at: index) as? WithPage)?
            .pageTitle ?? ""
        return TMBarItem(title: title)
    }
}
