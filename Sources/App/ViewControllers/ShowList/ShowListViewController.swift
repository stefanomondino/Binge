//
//  ShowListViewController.swift
//  App
//

import UIKit
import ViewModel
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
        return 1.0
//        let size = collectionView.automaticSizeForItem(at: indexPath, itemsPerLine: 3)
//        return size.width / size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: PluginLayout, effectsForItemAt indexPath: IndexPath, kind: String?) -> [PluginEffect] {
        guard kind == nil else { return [] }
        return [ElasticEffect(spacing: 100, span: 100)]
    }
}

class ShowListViewController: UIViewController {
    
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    func configure(with viewModel: ShowListViewModel) {
//        let spacing: CGFloat = 4.0
//        let delegate = ShowListDelegate()
//            .with(lineSpacing: { _, _ in return spacing })
//            .with(itemSpacing: { _, _ in return spacing })
//            .with(insets: { _, _ in return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)})
//            .with(select: { viewModel.interact(.selectItem($0)) })
//
//        let layout = StaggeredLayout()
//        collectionView.backgroundColor = .clear
//
//        self.view.backgroundColor = .greyishWhite
//        collectionView.setCollectionViewLayout(layout, animated: false)
//
//        collectionView.boomerang.configure(with: viewModel, delegate: delegate)
//
//        rx.viewDidAppear().take(1).bind { viewModel.load() }.disposed(by: disposeBag)
//
//    }
}
