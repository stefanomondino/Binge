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
    @IBOutlet var subtitle: UILabel?
    @IBOutlet var otherLabel: UILabel?
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
        guard let viewModel = viewModel as? GenericItemViewModel
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
        if let otherLabel = self.otherLabel {
            otherLabel.applyStyle(.itemSubtitle)

            otherLabel.text = viewModel.moreText
            otherLabel.numberOfLines = 1
        }

        backgroundColor = .clear

        if isPlaceholderForAutosize { return }
        if let image = self.image {
            viewModel.image
                .observeOn(Scheduler.background)
                .map { $0.circled() }
                .asDriver(onErrorJustReturn: UIImage())
                .startWith(UIImage())
                .drive(image.rx.animatedImage())
                .disposed(by: disposeBag)
        }
    }
}
