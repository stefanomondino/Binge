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
    var disposeBag = DisposeBag()
    @IBOutlet var collectionView: UICollectionView!
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
    
    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = collectionViewDelegate
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)
        
        let spacing: CGFloat = 9
        self.collectionViewDelegate = ShowListDelegate(viewModel: viewModel, dataSource: collectionViewDataSource)
            .withItemsPerLine(itemsPerLine: 1)
            .withInsets { _, _ in return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) }
            .withItemSpacing { _, _ in return spacing }
            .withLineSpacing { _, _ in return spacing }
            .withSelect { viewModel.selectItem(at: $0) }
        
        collectionView.backgroundColor = .clear
        
        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
        
        viewModel.reload()
        
    }
}
