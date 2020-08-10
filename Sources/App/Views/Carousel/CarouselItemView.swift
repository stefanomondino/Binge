//
//  CarouselItemView.swift
//  App
//

import Boomerang
import RxCocoa
import RxSwift
import UIKit

class CarouselItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var collectionView: UICollectionView!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

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

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? CarouselItemViewModel
        else { return }

        if isPlaceholderForAutosize { return }
        backgroundColor = .clear
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: viewModel.cellFactory)

        if let collectionView = self.collectionView {
            let sizeCalculator = CarouselSizeCalculator(ratio: 9 / 16)

            let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
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

class CarouselSizeCalculator: CollectionViewSizeCalculator {
    let ratio: CGFloat
    init(ratio: CGFloat) {
        self.ratio = ratio
    }

    func insets(for _: UICollectionView, in _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func itemSpacing(for _: UICollectionView, in _: Int) -> CGFloat {
        return 4
    }

    func lineSpacing(for _: UICollectionView, in _: Int) -> CGFloat {
        return 4
    }

    func sizeForItem(at indexPath: IndexPath, in collectionView: UICollectionView, direction _: Direction?, type: String?) -> CGSize {
        if type != nil { return .zero }
        let height = calculateFixedDimension(for: .horizontal, collectionView: collectionView, at: indexPath, itemsPerLine: 1)
        let width = height * ratio
        return CGSize(width: width, height: height)
    }
}

// extension CollectionViewDelegate {
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
// }
