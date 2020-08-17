//
//  PersonItemView.swift
//  App
//

import Boomerang
import RxCocoa
import RxSwift
import UIKit

class SeasonItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
    @IBOutlet var image: UIImageView?

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowItemViewModel
        else { return }
        if let title = self.title {
            title.applyStyle(.itemTitle)

            title.text = viewModel.title
            title.numberOfLines = 1
        }
        if let subtitle = self.subtitle {
            subtitle.applyStyle(.itemSubtitle)

            subtitle.text = viewModel.subtitle
            subtitle.numberOfLines = 1
        }

        backgroundColor = .clear

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
