//
//  ShowListViewController.swift
//  App
//

import UIKit
import Boomerang
import SnapKit
import RxSwift
import RxCocoa
import PluginLayout

class ShowListDelegate: CollectionViewDelegate, StaggeredLayoutDelegate, PluginLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: PluginLayout, lineCountForSectionAt section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: PluginLayout, aspectRatioAt indexPath: IndexPath) -> CGFloat {
        
        let size = self.sizeCalculator(for: collectionView)
            .automaticSizeForItem(at: indexPath, itemsPerLine: 3)
        return size.width / size.height 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: PluginLayout, effectsForItemAt indexPath: IndexPath, kind: String?) -> [PluginEffect] {
        guard kind == nil else { return [] }
        return [ElasticEffect(spacing: 100, span: 100)]
    }
}

class ShowListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ShowListViewModel
    
    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = collectionViewDataSource
            self.collectionView.reloadData()
        }
    }
    
    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = collectionViewDelegate
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: CollectionViewCellFactory
    
    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: ShowListViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)
        viewModel.styleFactory.apply(.container, to: self.view)
        let spacing: CGFloat = 9
        let collectionViewDelegate = ShowListDelegate(viewModel: viewModel, dataSource: collectionViewDataSource)
            .withItemsPerLine(itemsPerLine: 3)
            .withInsets { _, _ in return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) }
            .withItemSpacing { _, _ in return spacing }
            .withLineSpacing { _, _ in return spacing }
            .withSelect { viewModel.selectItem(at: $0) }
        
        let layout = StaggeredLayout()
        collectionView.backgroundColor = .clear
        
        

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
        
        if let viewModel = viewModel as? RxNavigationViewModel {
            viewModel.routes
                .bind(to: self.rx.routes())
                .disposed(by: disposeBag)
        }
        
        self.collectionViewDelegate = collectionViewDelegate
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        viewModel.reload()
        
    }
}

extension Reactive where Base: UIViewController {
    func routes() -> Binder<Route> {
        return Binder(base) { base, route in
            route.execute(from: base)
        }
    }
}
