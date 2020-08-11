//
//  PersonItemView.swift
//  App
//

import Boomerang
import RxCocoa
import RxSwift
import UIKit

class PersonItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var image: UIImageView?

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? PersonItemViewModel
        else { return }
        if let title = self.title {
            title.applyStyle(Styles.Generic.title)

            title.text = viewModel.title
            title.numberOfLines = 1
        }
        applyContainerStyle(Styles.Generic.card)

        if isPlaceholderForAutosize { return }
        if let image = self.image {
            viewModel.image
                .asDriver(onErrorJustReturn: UIImage())
                .startWith(UIImage())
                .drive(image.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
