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

class UserViewController: UIViewController {
    var viewModel: UserViewModel
    @IBOutlet var collectionView: UICollectionView!

    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: CollectionViewCellFactory

    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            collectionView.delegate = collectionViewDelegate
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: UserViewModel,
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

//        loginButton.rx.tap.bind { viewModel.openLogin() }.disposed(by: disposeBag)
        view.applyContainerStyle(.container)
        collectionView.backgroundColor = .clear
        viewModel.routes
            .bind(to: rx.routes())
            .disposed(by: disposeBag)

        title = viewModel.pageTitle
        setupCollectionView()
        setupSettings()
        setupLoginView()
    }

    func setupCollectionView() {
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        collectionView.alwaysBounceVertical = true
        view.applyContainerStyle(.container)

        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory, itemsPerLine: 1)

        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        collectionView.backgroundColor = .clear
        self.collectionViewDelegate = collectionViewDelegate

        collectionView.rx
            .reloaded(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
        viewModel.reload()
    }

    func setupSettings() {
        let settings = UIButton(type: .system)
        settings.setImage(Asset.settings.image, for: .normal)
        settings.rx.tap.bind { [weak self] in self?.viewModel.openSettings() }.disposed(by: disposeBag)
        addRightNavigationView(settings)
    }

    func setupLoginView() {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        collectionView.backgroundView = button
        button.rx.tap.bind { [weak self] in self?.viewModel.openLogin() }.disposed(by: disposeBag)
        viewModel
            .isLoginHidden
            .asDriver(onErrorJustReturn: false)
            .drive(button.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
