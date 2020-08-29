//
//  SettingsViewController.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Boomerang
import Foundation
import RxCocoa
import RxSwift

class SettingsListViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    var viewModel: SettingsListViewModelType

    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            collectionView.delegate = collectionViewDelegate
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: CollectionViewCellFactory

    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: SettingsListViewModelType,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
        override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
    #endif

    override func viewDidLoad() {
        collectionView.backgroundColor = .clear
        super.viewDidLoad()

        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        collectionView.alwaysBounceVertical = true
        view.applyContainerStyle(.container)

        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory, itemsPerLine: 1)

        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        collectionView.backgroundColor = .clear

        collectionView.rx
            .reloaded(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)

        self.collectionViewDelegate = collectionViewDelegate

//        viewModel
//            .routes
//            .bind(to: rx.routes())
//            .disposed(by: disposeBag)

        viewModel.reload()

//        viewModel.navbarTitleViewModel
//            .asDriver(onErrorJustReturn: nil)
//            .drive(onNext: { [weak self] in
//                if let viewModel = $0 {
//                    self?.setNavigationView(self?.collectionViewCellFactory.component(from: viewModel))
//                } else {
//                    self?.title = viewModel.title
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
