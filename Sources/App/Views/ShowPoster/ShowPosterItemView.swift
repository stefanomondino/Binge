//
//  ShowPosterItemView.swift
//  App
//

import UIKit
import ViewModel
import RxSwift
import RxCocoa
import Boomerang
/**
    A Boomerang ItemView for ShowPoster contents.

    Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.
    
*/
class ShowPosterItemView: UIView, WithViewModel {
    
    @IBOutlet weak var title: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()

        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here       
//        self.title.text = viewModel.title
//
//        if self.isPlaceholderForAutosize { return }

        /// Configure here every property that doesn't contributes to change view size
        /// UIImage bindings should go here
    }
}
