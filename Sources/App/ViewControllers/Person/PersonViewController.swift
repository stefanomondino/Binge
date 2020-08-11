//
//  PersonViewController.swift
//  App
//

import Boomerang
import PluginLayout
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class PersonViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    var viewModel: PersonViewModel

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
         viewModel: PersonViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        view.applyContainerStyle(Styles.Generic.container)

        let spacing: CGFloat = 10
        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory, itemsPerLine: 1)
            .withItemSpacing { _, _ in spacing }
            .withLineSpacing { _, _ in spacing }
            .withInsets { _, _ in UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) }

        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        collectionView.backgroundColor = .clear

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)

        if let viewModel = viewModel as? RxNavigationViewModel {
            viewModel.routes
                .observeOn(MainScheduler.instance)
                .bind { [weak self] route in
                    route.execute(from: self)
                }.disposed(by: disposeBag)
        }

        self.collectionViewDelegate = collectionViewDelegate

        viewModel.routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        viewModel.reload()
    }
}
