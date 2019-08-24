//
//  PagerViewController.swift
//  App
//
//  Created by Stefano Mondino on 10/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Tabman
import Pageboy
import RxSwift
import ViewModel
import Boomerang


class PagerViewController: TabmanViewController, ViewModelCompatibleType {
    var viewModel: ListViewModelType?
    private var internalDataSource: PagerDataSource?
    
    func set(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? ListViewModelType else {
            return
        }
        self.viewModel = viewModel
        let dataSource = PagerDataSource(viewModel: viewModel)
        self.dataSource = dataSource
        self.internalDataSource = dataSource
        
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: {[weak self] update in
                switch update {
                case .reload(let reload):
                    _ = reload()
                    dataSource.clear()
                    self?.reloadData()
                case .insertItems(let update):
                    let indexes = update()
                    indexes.compactMap { $0.last }.forEach {
                        self?.insertPage(at: $0, then: .scrollToUpdate)
                    }
                case .deleteItems(let update):
                    let indexes = update()
                    indexes.compactMap { $0.last }
                        .sorted()
                        .reversed()
                        .forEach {
                            self?.deletePage(at: $0, then: .scrollToUpdate)
                    }
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
        bar.backgroundView.style = .flat(color: Color.navbarColor)
        bar.buttons.customize { (button) in
            button.tintColor = .white
            button.font = Fonts.main(.bold).font(size: 14)
            button.tintColor = UIColor(white: 1.0, alpha: 0.6)
            button.selectedTintColor = .white
            //            button.contentInset = UIEdgeInsets(top: 18, left: 30, bottom: 0, right: 30)
        }
        
        bar.layout.contentMode = .intrinsic
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 50, bottom: 0, right: 50)
        bar.indicator.tintColor = .white
        bar.indicator.overscrollBehavior = .compress
        
        self.addBar(bar, dataSource: dataSource, at: .top)
        
        self.rx.viewDidAppear()
            .take(1)
            .bind {
                viewModel.load()
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        self.automaticallyAdjustsChildInsets = true
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class PagerDataSource: PageboyViewControllerDataSource, TMBarDataSource, TMBarDelegate {
    
    let viewModel: ListViewModelType
    var viewControllers: [PageboyViewController.PageIndex: UIViewController] = [:]
    
    func clear() {
        viewControllers = [:]
    }
    
    public var dataHolder: DataHolder {
        return viewModel.dataHolder
    }
    private var rootGroup: DataGroup {
        return dataHolder.modelGroup
    }
    init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return rootGroup.data.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        if let vc = viewControllers[index] {
            return vc
        }
        
        guard let viewModel = self.viewModel.mainViewModel(at: IndexPath(indexes: [index])) as? SceneViewModelType,
            let viewController = viewModel.sceneIdentifier.scene() as?  (UIViewController & ViewModelCompatibleType)  else {
                return nil
        }
        
        viewController.loadViewAndSet(viewModel: viewModel)
        if #available(iOS 11.0, *) {
            var insets = viewController.additionalSafeAreaInsets
            insets.top = 0 //((pageboyViewController as? TabmanViewController)?.barInsets ?? .zero).top
            viewController.additionalSafeAreaInsets = insets
        } else {
            // Fallback on earlier versions
        }
        self.viewControllers[index] = viewController
        return viewController
        
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = (self.viewModel.mainViewModel(at: IndexPath(indexes: [index])) as? PageViewModel)?.mainTitle ?? ""
        return TMBarItem(title: title.uppercased())
    }
    
    func bar(_ bar: TMBar, didRequestScrollTo index: Int) {
        
    }
}
