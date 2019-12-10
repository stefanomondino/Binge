//
//  {{ name|firstUppercase }}ItemView.swift
//  {{ target|firstUppercase }}
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

class {{ name|firstUppercase }}ItemView: UIView, WithViewModel {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var image: UIImageView?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? {{ name|firstUppercase }}ItemViewModel 
        else { return }
        
        viewModel.styleFactory.apply(.title, to: title)
        title.text = viewModel.title
        
        if self.isPlaceholderForAutosize { return }
        if let image = self.image {
            viewModel.image
                .asDriver(onErrorJustReturn: UIImage())
                .drive(image.rx.image)
                .disposed(by: disposeBag)
        }
    }
}