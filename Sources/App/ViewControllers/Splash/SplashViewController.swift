//
//  SplashViewController.swift
//  App
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxSwift
import SnapKit
import UIKit

class SplashViewController: UIViewController {
    let viewModel: SplashViewModel
    let disposeBag = DisposeBag()
    init(
        nibName: String? = nil,
        viewModel: SplashViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()?.view {
            view.insertSubview(launchScreen, at: 0)
            launchScreen.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        viewModel.routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        viewModel.start()
    }
}
