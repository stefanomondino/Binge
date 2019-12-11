//
//  PagerViewController.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Tabman
import Boomerang
import RxSwift

class TabViewController: UITabBarController {
    
    let viewModel: ListViewModel
    let styleFactory: StyleFactory
    let routeFactory: RouteFactory
    var disposeBag = DisposeBag()
    init(viewModel: ListViewModel,
         routeFactory: RouteFactory,
         styleFactory: StyleFactory
    ) {
        self.viewModel = viewModel
        self.styleFactory = styleFactory
        self.routeFactory = routeFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleFactory.apply(.container, to: self.view)
        let factory = routeFactory
        let configurationClosure = { (sections: [Section]) -> [Scene] in
            sections.flatMap {
                $0.items.compactMap { item in
                    let vc = factory.pageRoute(from: item).createScene()
                    vc?.tabBarItem.title = (item as? WithPage)?.pageTitle
                    vc?.tabBarItem.image = (item as? WithPage)?.pageIcon
                    return vc
                }
            }
        }
        
        if let rx = viewModel as? RxListViewModel {
            
            rx.sectionsRelay
                .map { configurationClosure($0) }
                .asDriver(onErrorJustReturn: [])
                .drive(onNext: { [weak self] in self?.viewControllers = $0 })
                .disposed(by: disposeBag)
        } else {
            viewModel.onUpdate = {[weak self] in
                configurationClosure(self?.viewModel.sections ?? [])
            }
        }
        viewModel.reload()
    }
}

//
//typealias PagerButton = Tabman.TMLabelBarButton
//
//class PagerViewController: TabmanViewController {
//    let viewModel: ListViewModel
//    let styleFactory: StyleFactory
//    let internalDataSource: PagerDataSource
//    init(viewModel: ListViewModel,
//         routeFactory: RouteFactory,
//         styleFactory: StyleFactory
//         ) {
//        self.viewModel = viewModel
//        self.styleFactory = styleFactory
//        self.internalDataSource = PagerDataSource(viewModel: viewModel, factory: routeFactory)
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        self.automaticallyAdjustsChildInsets = true
//        super.viewDidLoad()
//
//        styleFactory.apply(.container, to: self.view)
//
//        self.dataSource = internalDataSource
//        self.setupBar()
//        viewModel.onUpdate = { [weak self] in
//            DispatchQueue.main.async {
//                self?.internalDataSource.clear()
//                self?.reloadData()
//            }
//
//        }
//        viewModel.reload()
//    }
//    private func setupBar() {
//        let styleFactory = self.styleFactory
//        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
//        bar.backgroundView.style = .flat(color: .clear)
//        bar.buttons.customize { (button) in
//            styleFactory.apply(.title, to: button)
//        }
//
//        bar.layout.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
//        bar.indicator.tintColor = .darkGray
//        bar.indicator.weight = .custom(value: 2)
//
//        self.addBar(bar, dataSource: internalDataSource, at: .top)
//    }
//
//}
//
