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

class LoginViewController: UIViewController {
    var viewModel: LoginViewModel
    @IBOutlet var loginButton: UIButton!

    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: CollectionViewCellFactory

    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: LoginViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel

        loginButton.rx.tap.bind { viewModel.openLogin() }.disposed(by: disposeBag)

        viewModel.routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)
    }
}
