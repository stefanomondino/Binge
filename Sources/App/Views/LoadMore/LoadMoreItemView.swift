//
//  LoadMoreItemView.swift
//  App
//

import Boomerang
import RxCocoa
import RxSwift
import UIKit
/**
 A Boomerang ItemView for LoadMore contents.

 Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.

 */
class LoadMoreItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel!
    @IBOutlet var activityIndicator: RingLoaderView!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 80, height: 80)
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? LoadMoreItemViewModel else { return }
        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here

        if isPlaceholderForAutosize { return }
//
//        viewModel.start().disposed(by: disposeBag)
        viewModel.reload().disposed(by: disposeBag)
        activityIndicator.lineWidth = 2
        activityIndicator.tintColor = .navbarText
        activityIndicator.isAnimating = true

        /// Configure here every property that doesn't contributes to change view size
        /// UIImage bindings should go here
    }
}
