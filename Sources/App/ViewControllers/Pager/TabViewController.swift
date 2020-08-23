//
//  PagerViewController.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxSwift
import UIKit

class TabViewController: UITabBarController {
    let viewModel: ListViewModel
    let styleFactory: StyleFactory
    let routeFactory: RouteFactory
    var disposeBag = DisposeBag()
    #if os(iOS)
        var statusBarStyle: UIStatusBarStyle = .lightContent {
            didSet {
                setNeedsStatusBarAppearanceUpdate()
            }
        }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            statusBarStyle
        }

        override var childForStatusBarStyle: UIViewController? {
            nil
        }
    #endif

    init(viewModel: ListViewModel,
         routeFactory: RouteFactory,
         styleFactory: StyleFactory)
    {
        self.viewModel = viewModel
        self.styleFactory = styleFactory
        self.routeFactory = routeFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyContainerStyle(.navigationBar)
        applyContainerStyle(.navigationBar)
        let factory = routeFactory
        let configurationClosure = { (sections: [Section]) -> [UIViewController] in
            sections.flatMap {
                $0.items.compactMap { item in
                    let viewController = factory.page(from: item).createScene() as? UIViewController
                    viewController?.tabBarItem.title = (item as? WithPage)?.pageTitle
                    viewController?.tabBarItem.image = (item as? WithPage)?.pageIcon?.resized(to: CGSize(width: 30, height: 30))
                    return viewController
                }
            }
        }

        if let rxViewModel = viewModel as? RxListViewModel {
            rxViewModel.sectionsRelay
                .map { configurationClosure($0) }
                .asDriver(onErrorJustReturn: [])
                .drive(onNext: { [weak self] in self?.viewControllers = $0 })
                .disposed(by: disposeBag)
        } else {
            viewModel.onUpdate = { [weak self] in
                _ = configurationClosure(self?.viewModel.sections ?? [])
            }
        }
        viewModel.reload()
        #if os(iOS)
            setNeedsStatusBarAppearanceUpdate()
        #endif
    }
}
