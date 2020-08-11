//
//  ShowDetailViewController.swift
//  App
//

import Boomerang
import PluginLayout
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ShowDetailViewController: UIViewController {
    class SizeCalculator: AutomaticCollectionViewSizeCalculator {
        override func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView, direction: Direction? = nil, type: String? = nil) -> CGSize {
            guard let vm = viewModel(at: indexPath, for: type) else { return .zero }
            let width = calculateFixedDimension(for: .vertical, collectionView: collectionView, at: indexPath, itemsPerLine: 1)
            switch vm {
            case is CarouselItemViewModel: return CGSize(width: width, height: 200)
            default: return super.sizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
            }
        }
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundImage: UIImageView!

    var viewModel: ShowDetailViewModel

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
         viewModel: ShowDetailViewModel,
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
        let sizeCalculator = SizeCalculator(viewModel: viewModel,
                                            factory: collectionViewCellFactory, itemsPerLine: 1)

        let collectionViewDelegate = ShowListDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        collectionView.backgroundColor = .clear

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)

        self.collectionViewDelegate = collectionViewDelegate

        viewModel
            .routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        viewModel.reload()

        if let container = self.container {
            collectionView.rx
                .topWindow(of: 400)
                .bind(to: container.rx.updateCurrentScroll())
                .disposed(by: disposeBag)
        }
    }
}
