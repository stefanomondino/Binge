//
//  CarouselItemView.swift
//  App
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

class CarouselItemView: UIView, WithViewModel {
    
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
    
    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? CarouselItemViewModel 
            else { return }
        
        if self.isPlaceholderForAutosize { return }
        self.backgroundColor = .clear
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: viewModel.cellFactory)
        
        if let collectionView = self.collectionView {
            let spacing: CGFloat = 10
            let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                       factory: viewModel.cellFactory, itemsPerLine: 1)
                .withItemSpacing { _, _ in return spacing }
                .withLineSpacing { _, _ in return spacing }
                .withInsets { _, _ in return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) }
                
            
            let collectionViewDelegate = ShowListDelegate(sizeCalculator: sizeCalculator)
                .withSelect { viewModel.selectItem(at: $0) }
            
            collectionView.backgroundColor = .clear
            
            collectionView.rx
                .animated(by: viewModel, dataSource: collectionViewDataSource)
                .disposed(by: disposeBag)
            
            self.collectionViewDelegate = collectionViewDelegate
            viewModel.reload()
        }
    }
}

//extension CollectionViewDelegate {
//    open func withAspectRatio(_ ratio: CGFloat, direction: Direction) -> Self {
//        return self.withSize(size: {[weak self] collectionView, indexPath, type in
//            guard let self = self else {
//                return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
//            }
//            if type != nil { return .zero }
//            let fixed = self.sizeCalculator(for: collectionView)
//                .calculateFixedDimension(for: direction, at: indexPath, itemsPerLine: 1, type: type)
//            switch direction {
//            case .horizontal: return CGSize(width: fixed * ratio, height: fixed)
//            case .vertical: return CGSize(width: fixed, height: fixed / ratio)
//            @unknown default: return CGSize(width: fixed, height: fixed)
//            }
//            
//        })
//    }
//}
