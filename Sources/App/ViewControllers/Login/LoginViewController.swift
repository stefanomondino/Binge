//
//  LoginViewController.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxRelay
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    let viewModel: LoginViewModel
    let collectionViewCellFactory: CollectionViewCellFactory
    @IBOutlet weak var stackView: UIStackView!
    var disposeBag = DisposeBag()
    
    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: LoginViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        
        let viewModel = self.viewModel
        
        stackView.spacing = 10
        
        stackView.rx
            .bind(viewModel: viewModel, factory: collectionViewCellFactory)
            .disposed(by: disposeBag)
        
        stackView.backgroundColor = .clear

        viewModel.reload()
        
    }
}

