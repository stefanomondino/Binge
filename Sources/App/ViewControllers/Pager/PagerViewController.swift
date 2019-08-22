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
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .flat(color: .black)
        bar.buttons.customize { (button) in
            button.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
            button.tintColor = .white
//            button.font = Fonts.special(.regular).font(size: 20)
            button.font = Fonts.main(.bold).font(size: 20)
            button.selectedTintColor = .white
        }
        
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 50, bottom: 14, right: 50)
        bar.indicator.tintColor = .white
        bar.indicator.weight = .custom(value: 3)
        
        self.addBar(bar, dataSource: dataSource, at: .top)
        viewModel.load()
    }
    
    override func viewDidLoad() {
        self.automaticallyAdjustsChildInsets = false
        super.viewDidLoad()
        
    }
    
}

class PagerDataSource: PageboyViewControllerDataSource, TMBarDataSource {
    
    let viewModel: ListViewModelType
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
        
        guard let viewModel = self.viewModel.mainViewModel(at: IndexPath(indexes: [index])) as? SceneViewModelType,
            let viewController = viewModel.sceneIdentifier.scene() as?  (UIViewController & ViewModelCompatibleType)  else {
            return nil
        }
        
        viewController.loadViewAndSet(viewModel: viewModel)
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
        let title = (self.viewModel.mainViewModel(at: IndexPath(indexes: [index])) as? ViewModel.PageViewModelType)?.mainTitle ?? ""
        return TMBarItem(title: title.uppercased())
    }
    
}
