//
//  PagerDataSource.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Tabman
import Pageboy
import Boomerang

class PagerDataSource: PageboyViewControllerDataSource, TMBarDataSource {
    
    let viewModel: ListViewModel
    let factory: RouteFactory
    init(viewModel: ListViewModel, factory: RouteFactory) {
        self.viewModel = viewModel
        self.factory = factory
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
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
        let items = viewModel.sections.flatMap { $0.items }
        guard let viewController = factory
            .pageRoute(from: items[index])
            .createScene() else { return nil }
        
        if #available(iOS 11.0, *) {
            var insets = viewController.additionalSafeAreaInsets
            insets.top += ((pageboyViewController as? TabmanViewController)?.barInsets ?? .zero).top
            viewController.additionalSafeAreaInsets = insets
        } else {
            // Fallback on earlier versions
        }
        return viewController
        
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        //        let title = (self.viewModel.mainViewModel(at: IndexPath(indexes: [index])) as? PageViewModel)?.mainTitle ?? ""
        return TMBarItem(title: "TEST")
    }
    
}
