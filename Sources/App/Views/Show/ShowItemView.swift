//
//  ShowItemView.swift
//  App
//

import UIKit
import ViewModel
import RxSwift
import RxCocoa
import Boomerang
/**
    A Boomerang ItemView for Show contents.

    Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.
    
*/
class ShowItemView: UIView, ViewModelCompatible {
    typealias ViewModel = ShowItemViewModel
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var counter: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()

        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here
        self.title.style = Identifiers.Styles.mainRegularStyle.style
        self.title.styledText = viewModel.title

        self.counter?.style = Identifiers.Styles.mainFilledButton.style
        self.counter?.styledText = viewModel.counter ?? ""
        
        if self.isPlaceholderForAutosize { return }

        viewModel.poster
            .asDriver(onErrorJustReturn: UIImage())
            .startWith(UIImage())
            .drive(poster.rx.image)
            .disposed(by: disposeBag)
        
        /// Configure here every property that doesn't contributes to change view size
        /// UIImage bindings should go here
    }
}
