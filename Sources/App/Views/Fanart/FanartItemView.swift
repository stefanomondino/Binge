//
//  FanartItemView.swift
//  App
//

import Boomerang
import RxCocoa
import RxSwift
import SnapKit
import UIKit
class FanartItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var image: UIImageView!

    var disposeBag = DisposeBag()
    var constraint: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? FanartItemViewModel
        else { return }
        removeConstraints([constraint].compactMap { $0 })
        snp.makeConstraints { make in
            self.constraint = make.width
                .lessThanOrEqualTo(self.image.snp.height)
                .multipliedBy(viewModel.ratio)
                .constraint.layoutConstraints
                .first
        }

        if isPlaceholderForAutosize { return }
        backgroundColor = .clear
        if let image = self.image {
            viewModel.image
                .asDriver(onErrorJustReturn: UIImage())
                .startWith(UIImage())
                .drive(image.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
