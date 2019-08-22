//
//  CarouselItemView.swift
//  App
//

import UIKit
import ViewModel
import RxSwift
import RxCocoa
import Boomerang
/**
    A Boomerang ItemView for Carousel contents.

    Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.
    
*/
class CarouselItemView: UIView, ViewModelCompatible {
    typealias ViewModel = CarouselItemViewModel
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: ViewModel) {
        let spacing: CGFloat = 10.0
        
        self.disposeBag = DisposeBag()
        
        self.collectionView.backgroundColor = viewModel.backgroundColor
        
        self.heightConstraint.constant = viewModel.size.height() + 2 * spacing
                
        if self.isPlaceholderForAutosize { return }
        
        let delegate = CollectionViewDelegate()
            .with(size: { cv, ip, type -> CGSize in
                guard type == nil else {
                    return .zero
                }
                
                let w = cv.boomerang.calculateFixedDimension(for: .vertical, at: ip, itemsPerLine: viewModel.size.itemsPerLine())
                let h = cv.boomerang.calculateFixedDimension(for: .horizontal, at: ip, itemsPerLine: 1)
                
                return CGSize(width: w, height: h)
            })
            .with(lineSpacing: { _, _ in return 8 })
            .with(itemSpacing: { _, _ in return 8 })
            .with(select: { viewModel.interact(.selectItem($0)) })
            .with(insets: { _, _ in
                return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            })
        
        collectionView
            .boomerang
            .configure(with: viewModel, delegate: delegate)
        
        viewModel.load()
    }
}
