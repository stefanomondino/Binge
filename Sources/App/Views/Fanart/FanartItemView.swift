//
//  FanartItemView.swift
//  App
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang
import SnapKit
class FanartItemView: UIView, WithViewModel {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var image: UIImageView!
    
    var disposeBag = DisposeBag()
    var constraint: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? FanartItemViewModel 
        else { return }
        self.removeConstraints([constraint].compactMap { $0 })
        self.snp.makeConstraints { (make) in
            self.constraint = make.width.equalTo(self.image.snp.height).multipliedBy(viewModel.ratio).constraint.layoutConstraints.first
        }
        
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
