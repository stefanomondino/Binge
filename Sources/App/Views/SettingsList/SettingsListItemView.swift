//
//  SettingsListItemView.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Boomerang
import RxCocoa
import RxSwift
import SwiftRichString
import UIKit
/**
 A Boomerang ItemView for Show contents.

 Contents should be entirely driven by `ViewModel`, so that this view can safely deployed in production without being tested.

 */
class SettingsListItemView: UIView, WithViewModel {
    @IBOutlet var title: UILabel?

    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? FormViewModelType else { return }
        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here
        //        self.title.style = Identifiers.Styles.mainRegularStyle.style

        backgroundColor = .clear

//        applyContainerStyle(viewModel.mainStyle)

        if let title = title {
            title.applyStyle(.subtitle)
            viewModel.textValue
                .drive(onNext: { title.styledText = $0 })
                .disposed(by: disposeBag)
        }

        if isPlaceholderForAutosize { return }
    }

    override var canBecomeFocused: Bool { true }
}
