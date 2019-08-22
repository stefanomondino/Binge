//
//  LoginViewController.swift
//  App
//

import UIKit
import ViewModel
import Boomerang
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, ViewModelCompatible, InteractionCompatible {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var login: UIButton!
    
    func configure(with viewModel: LoginViewModel) {
        stackView.spacing = 4.0
        stackView.boomerang.configure(with: viewModel)
        
        login.rx.tap
            .bind { viewModel.interact(.login) }
            .disposed(by: disposeBag)
        
        viewModel.load()
    }
}
