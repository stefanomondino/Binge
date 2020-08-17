//
//  FanartItemView.swift
//  App
//

import Boomerang
import RxCocoa
import RxSwift
import SnapKit
import UIKit
class DescriptionItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var image: UIImageView!

    var disposeBag = DisposeBag()
    var constraint: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? DescriptionItemViewModel
        else { return }
        title?.numberOfLines = 0
        title?.applyStyle(.subtitle)
        title?.styledText = viewModel.description
        if isPlaceholderForAutosize { return }
        backgroundColor = .clear
    }
}
