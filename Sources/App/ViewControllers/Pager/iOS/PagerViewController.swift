//
//  PagerViewController.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Pageboy
import RxSwift
import Tabman
import UIKit
typealias PagerButton = Tabman.TMLabelBarButton

class PagerViewController: TabmanViewController {
    let viewModel: ListViewModel
    let styleFactory: StyleFactory
    let internalDataSource: PagerDataSource
    let disposeBag = DisposeBag()
    init(viewModel: ListViewModel,
         routeFactory: RouteFactory,
         styleFactory: StyleFactory) {
        self.viewModel = viewModel
        self.styleFactory = styleFactory
        internalDataSource = PagerDataSource(viewModel: viewModel, factory: routeFactory)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        automaticallyAdjustsChildInsets = true
        super.viewDidLoad()

        styleFactory.apply(.navigationBar, to: view)
        title = (viewModel as? PagerViewModel)?.pageTitle
        dataSource = internalDataSource
        setupBar()
        if let viewModel = viewModel as? RxListViewModel {
            viewModel.sectionsRelay.asDriver()
                .drive(onNext: { [weak self] _ in
                    self?.internalDataSource.clear()
                    self?.reloadData()
                })
                .disposed(by: disposeBag)
        } else {
            viewModel.onUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.internalDataSource.clear()
                    self?.reloadData()
                }
            }
        }
        DispatchQueue.main.async {
            self.viewModel.reload()
        }

        if let viewModel = viewModel as? RxNavigationViewModel {
            viewModel.routes
                .bind(to: rx.routes())
                .disposed(by: disposeBag)
        }

        if let viewModel = viewModel as? PagerViewModel,
            viewModel.isSearchable {
            let button = UIButton(type: .system)
            button.setImage(Asset.search.image, for: .normal)
            button.rx.tap.bind { viewModel.openSearch() }.disposed(by: disposeBag)
            addRightNavigationView(button)
        }
    }

    private func setupBar() {
        let styleFactory = self.styleFactory
        switch viewModel.layoutIdentifier {
        case SceneIdentifier.bigPager:
            let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
            bar.backgroundView.style = .flat(color: .navbarBackground)
            bar.buttons.customize { button in
                styleFactory.apply(.navigationBar, to: button)
            }
            bar.layout.contentInset = UIEdgeInsets(top: 10, left: Constants.sidePadding, bottom: 10, right: Constants.sidePadding)
            bar.indicator.tintColor = .mainDescription
            bar.indicator.weight = .custom(value: 0)
            bar.scrollMode = .none
            isScrollEnabled = false
            addBar(bar, dataSource: internalDataSource, at: .top)
        default:
            isScrollEnabled = true
            let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
            bar.backgroundView.style = .flat(color: .navbarBackground)
            bar.buttons.customize { button in
                styleFactory.apply(.navigationBar, to: button)
            }
            bar.layout.interButtonSpacing = Constants.sidePadding
            bar.layout.contentInset = UIEdgeInsets(top: 0, left: Constants.sidePadding, bottom: 0, right: Constants.sidePadding)
            bar.indicator.tintColor = .mainDescription
            bar.indicator.weight = .custom(value: 4)

            addBar(bar, dataSource: internalDataSource, at: .top)
        }
    }
}
