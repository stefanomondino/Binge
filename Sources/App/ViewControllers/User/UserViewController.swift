//
//  LoginViewController.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import PluginLayout
import RxCocoa
import RxRelay
import RxSwift
import UIKit

class UserViewController: UIViewController {
    class Delegate: CollectionViewDelegate, PluginLayoutDelegate {
        func collectionView(_: UICollectionView, layout _: PluginLayout, pluginForSectionAt section: Int) -> PluginType? {
            switch section {
            case 0: return DetailHeaderPlugin(delegate: self).with(\.offsetForFirstElement, to: 50)
            default: return FlowLayoutPlugin(delegate: self)
            }
        }

        func collectionView(_: UICollectionView, layout _: PluginLayout, effectsForItemAt _: IndexPath, kind: String?) -> [PluginEffect] {
            guard kind == ViewIdentifier.Supplementary.parallax.identifierString else { return [] }
            return [ZoomEffect(parallax: 0.7)]
        }
    }

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
        collectionView.backgroundColor = .clear
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        collectionView.alwaysBounceVertical = true
        view.applyContainerStyle(.container)

        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory, itemsPerLine: 1)

        let collectionViewDelegate = Delegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }
        let layout = PluginLayout()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        self.collectionViewDelegate = collectionViewDelegate

        collectionView.rx
            .reloaded(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
        viewModel.reload()
        setDisappearingNavbar(boundTo: collectionView).disposed(by: disposeBag)

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        collectionView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged).bind { viewModel.reload() }.disposed(by: disposeBag)
        viewModel.isLoading.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
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
