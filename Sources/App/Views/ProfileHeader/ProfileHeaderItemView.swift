import Boomerang
import RxCocoa
import RxSwift
import SwiftRichString
import UIKit
/**
 A Boomerang ItemView for Show contents.

 Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.

 */
class ProfileHeaderItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
    @IBOutlet var avatar: UIImageView?

    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        // Always clear disposeBag for proper cell recycle
        disposeBag = DisposeBag()

        guard let viewModel = viewModel as? ProfileHeaderItemViewModel else { return }
        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here

        backgroundColor = .clear

        if let title = title {
            title.applyStyle(.title)
            title.styledText = viewModel.title
        }
        if let subtitle = subtitle {
            subtitle.applyStyle(.subtitle)
            subtitle.styledText = viewModel.subtitle
        }

        if isPlaceholderForAutosize { return }
        if let avatar = avatar {
            viewModel.image
                .map { $0.circled() }
                .asDriver(onErrorJustReturn: .init())
                .drive(avatar.rx.animatedImage())
                .disposed(by: disposeBag)
        }
        // configure here everything not related to automatic sizing
    }

    override var canBecomeFocused: Bool { true }
}
