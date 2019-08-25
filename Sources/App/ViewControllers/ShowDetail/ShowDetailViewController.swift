//
//  ShowDetailViewController.swift
//  App
//

import UIKit
import ViewModel
import Boomerang
import SnapKit
import RxSwift
import RxCocoa

class ShowDetailViewController: UIViewController, ViewModelCompatible, InteractionCompatible {
    
    @IBOutlet weak var collectionView: UICollectionView!

    func configure(with viewModel: ShowDetailViewModel) {
        let spacing: CGFloat = 4.0
        let delegate = CollectionViewDelegate()
            .with(itemsPerLine: 1)
            .with(lineSpacing: { _, _ in return spacing })
            .with(itemSpacing: { _, _ in return spacing })
            .with(insets: { _, _ in return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)})
            .with(select: { viewModel.interact(.selectItem($0)) })
        
        collectionView.boomerang.configure(with: viewModel, delegate: delegate)
        
        viewModel.load()
    }
}
