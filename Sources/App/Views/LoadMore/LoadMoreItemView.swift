//
//  LoadMoreItemView.swift
//  App
//

import UIKit
import ViewModel
import RxSwift
import RxCocoa
import Boomerang
/**
    A Boomerang ItemView for LoadMore contents.

    Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.
    
*/
class LoadMoreItemView: UIView, WithViewModel {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 80, height: 80)
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()

        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here       
    
//        if self.isPlaceholderForAutosize { return }
//
//        viewModel.start().disposed(by: disposeBag)
        activityIndicator.startAnimating()
        
        /// Configure here every property that doesn't contributes to change view size
        /// UIImage bindings should go here
    }
}
