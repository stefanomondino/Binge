//
//  LoginViewController.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxCocoa
import RxRelay
import RxSwift
import UIKit

class LoginViewController: UIViewController, KeyboardAvoidable {
    var keyboardAvoidingView: UIView { scrollView }

    let viewModel: LoginViewModel
    let collectionViewCellFactory: CollectionViewCellFactory
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    var disposeBag = DisposeBag()

    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: LoginViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        let viewModel = self.viewModel

        stackView.spacing = 10

        stackView.rx
            .bind(viewModel: viewModel, factory: collectionViewCellFactory)
            .disposed(by: disposeBag)

        scrollView.backgroundColor = .blue

        viewModel.reload()
        viewModel.routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        setupKeyboardAvoiding().disposed(by: disposeBag)
    }
}
