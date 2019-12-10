//
//  PersonItemView.swift
//  App
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

class PersonItemView: UIView, WithViewModel {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var image: UIImageView?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? PersonItemViewModel 
        else { return }
        if let title = self.title {
            viewModel.styleFactory.apply(.title, to: title)
            title.text = viewModel.title
            title.numberOfLines = 1
        }
        viewModel.styleFactory.apply(.card, to: self)
        
        if self.isPlaceholderForAutosize { return }
        if let image = self.image {
            viewModel.image
                .asDriver(onErrorJustReturn: UIImage())
                .startWith(UIImage())
                .drive(image.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
