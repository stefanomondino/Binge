//
//  ShowItemView.swift
//  App
//

import UIKit
import SwiftRichString
import RxSwift
import RxCocoa
import Boomerang
/**
    A Boomerang ItemView for Show contents.

    Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.
    
*/
class ShowItemView: UIView, WithViewModel {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var counter: UILabel?
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here
//        self.title.style = Identifiers.Styles.mainRegularStyle.style
        
        self.counter?.text = ""
        
        viewModel.styleFactory.apply(.title, to: title)
        viewModel.styleFactory.apply(.card, to: self)
        title.text = viewModel.title
        
        if self.isPlaceholderForAutosize { return }
        viewModel.image
            .asDriver(onErrorJustReturn: UIImage())
            .drive(poster.rx.image)
            .disposed(by: disposeBag)
//
//        self.counter?.style = Identifiers.Styles.mainFilledButton.style
//        self.counter?.styledText = viewModel.counter ?? ""
//


//        viewModel.poster
//            .asDriver(onErrorJustReturn: UIImage())
//            .startWith(UIImage())
//            .drive(poster.rx.image)
//            .disposed(by: disposeBag)
        
        /// Configure here every property that doesn't contributes to change view size
        /// UIImage bindings should go here
    }
}
