//
//  ShowListViewController.swift
//  App
//

import Boomerang
import PluginLayout
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    var viewModel: ItemListViewModel

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
         viewModel: ItemListViewModel,
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

        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)
        view.applyContainerStyle(.container)
        title = viewModel.pageTitle
        let spacing: CGFloat = 4
        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory, itemsPerLine: 3)
            .withItemSpacing { _, _ in spacing }
            .withLineSpacing { _, _ in spacing }
            .withInsets { _, _ in UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) }

        let collectionViewDelegate = Delegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        let layout = StaggeredLayout()
        collectionView.backgroundColor = .clear

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)

        viewModel.routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        self.collectionViewDelegate = collectionViewDelegate

        collectionView.setCollectionViewLayout(layout, animated: false)

        viewModel.reload()
//
//        let button = UIButton(type: .system)
//        button.setImage(Asset.heart.image, for: .normal)
//        button.rx.tap.bind { print("!!!") }.disposed(by: disposeBag)
//        addRightNavigationView(button)
    }
}

extension ItemListViewController {
    class Delegate: CollectionViewDelegate, StaggeredLayoutDelegate, PluginLayoutDelegate {
        func collectionView(_: UICollectionView, layout _: PluginLayout, lineCountForSectionAt _: Int) -> Int {
            return 3
        }

        func collectionView(_ collectionView: UICollectionView, layout _: PluginLayout, aspectRatioAt indexPath: IndexPath) -> CGFloat {
            let size = sizeCalculator
                .sizeForItem(at: indexPath, in: collectionView, direction: nil, type: nil)
            return size.width / size.height
        }

        func collectionView(_: UICollectionView, layout _: PluginLayout, effectsForItemAt _: IndexPath, kind: String?) -> [PluginEffect] {
            guard kind == nil else { return [] }
            return [ElasticEffect(spacing: 100, span: 100)]
        }
    }
}
