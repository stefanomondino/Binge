//
//  LoginViewController.swift
//  App
//

import UIKit
import Boomerang
import SnapKit
import RxSwift
import RxCocoa
import PluginLayout

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel
    @IBOutlet weak var loginButton: UIButton!
    
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = self.viewModel
        
        loginButton.rx.tap.bind { viewModel.openLogin() }.disposed(by: disposeBag)
        
        viewModel.routes
            .bind(to: self.rx.routes())
            .disposed(by: disposeBag)
    }
}
