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
            title.applyStyle(.subtitle)
            title.styledText = viewModel.title
        }

        if isPlaceholderForAutosize { return }

        // configure here everything not related to automatic sizing
    }

    override var canBecomeFocused: Bool { true }
}
