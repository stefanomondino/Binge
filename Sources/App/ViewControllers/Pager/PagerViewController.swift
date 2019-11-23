//
//  PagerViewController.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Boomerang

class PagerViewController: TabmanViewController {
    let viewModel: ListViewModel
    let internalDataSource: PagerDataSource
    init(viewModel: ListViewModel,
         routeFactory: RouteFactory) {
        self.viewModel = viewModel
        self.internalDataSource = PagerDataSource(viewModel: viewModel, factory: routeFactory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func set(viewModel: ViewModelType) {
    //        guard let viewModel = viewModel as? ListViewModelType else {
    //            return
    //        }
    //        self.viewModel = viewModel
    //        let dataSource = PagerDataSource(viewModel: viewModel)
    //        self.dataSource = dataSource
    //        self.internalDataSource = dataSource
    //
    //        viewModel.updates
    //            .asDriver(onErrorJustReturn: .none)
    //            .drive(onNext: {[weak self] update in
    //                switch update {
    //                case .reload(let reload):
    //                    _ = reload()
    //                    self?.reloadData()
    //                case .insertItems(let update):
    //                    let indexes = update()
    //                    indexes.compactMap { $0.last }.forEach {
    //                        self?.insertPage(at: $0, then: .scrollToUpdate)
    //                    }
    //                case .deleteItems(let update):
    //                    let indexes = update()
    //                    indexes.compactMap { $0.last }
    //                        .sorted()
    //                        .reversed()
    //                        .forEach {
    //                        self?.deletePage(at: $0, then: .scrollToUpdate)
    //                    }
    //                default: break
    //                }
    //
    //            })
    //        .disposed(by: disposeBag)
    //        self.view.backgroundColor = .backgroundGrey
    //        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
    //        bar.backgroundView.style = .flat(color: .white)
    //        bar.buttons.customize { (button) in
    //            button.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    //            button.tintColor = .black
    ////            button.font = Fonts.special(.regular).font(size: 20)
    //            button.font = Fonts.main(.bold).font(size: 16)
    //            button.selectedTintColor = .black
    //        }
    //
    //        bar.layout.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    //        bar.indicator.tintColor = .greyishTeal
    //        bar.indicator.weight = .custom(value: 2)
    //
    //        self.addBar(bar, dataSource: dataSource, at: .top)
    //        viewModel.load()
    //    }
    
    override func viewDidLoad() {
        self.automaticallyAdjustsChildInsets = true
        super.viewDidLoad()
        
        self.dataSource = internalDataSource
        self.setupBar()
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadData()
            }
            
        }
        viewModel.reload()
    }
    private func setupBar() {
        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
        bar.backgroundView.style = .flat(color: .white)
        bar.buttons.customize { (button) in
            button.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
            button.tintColor = .black
            //            button.font = Fonts.special(.regular).font(size: 20)
//            button.font = Fonts.main(.bold).font(size: 16)
            button.selectedTintColor = .black
        }
        
        bar.layout.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        bar.indicator.tintColor = .darkGray
        bar.indicator.weight = .custom(value: 2)
        
        self.addBar(bar, dataSource: internalDataSource, at: .top)
    }
    
}

