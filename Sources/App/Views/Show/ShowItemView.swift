//
//  ShowItemView.swift
//  App
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
class ShowItemView: UIView, WithViewModel {
    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel?
    @IBOutlet var counter: UILabel?
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        /// Configure here every property that contributes to change view size
        /// Multiline text bindings should go here
        //        self.title.style = Identifiers.Styles.mainRegularStyle.style

        counter?.text = viewModel.counter
        backgroundColor = .clear
        poster.applyContainerStyle(viewModel.mainStyle)
//        applyContainerStyle(viewModel.mainStyle)

        if let title = title {
            title.applyStyle(viewModel.mainStyle)
            title.text = viewModel.title
        }
        if let counter = counter {
            counter.applyStyle(Styles.Generic.subtitle)
            counter.text = viewModel.counter
        }
        if isPlaceholderForAutosize { return }
        viewModel.image
            .asDriver(onErrorJustReturn: UIImage())
            .drive(poster.rx.animatedImage())
            .disposed(by: disposeBag)
    }
}

//
// #if canImport(SwiftUI) && DEBUG
// import SwiftUI
// import Model
// @available(iOS 13.0, *)
//
// struct ShowItemView_Preview: PreviewProvider {
//    static var previewContainer = DefaultAppDependencyContainer()
//    static var previews: some View {
//
//        ForEach(ShowIdentifier.allCases, id: \.identifierString) { id in
//
//            Group {
////                Text(id.identifierString)
//
//            UIViewPreview {
//                {
//                    let vm = ShowItemViewModel.preview(id)
//                    let view =  previewContainer.viewFactory.component(from: vm) ?? UIView()
//                    view.frame = .zero
//                    return view
//                }()
//                }
//                .padding()
//                .border(Color.black, width: 2)
//                .padding()
////            .border(Color.black, width: 4)
////            .padding(10)
//
//
//
//            }
//        }
//
////        .padding(10)
//        .previewLayout(.sizeThatFits)
//
//    }
// }
// #endif
