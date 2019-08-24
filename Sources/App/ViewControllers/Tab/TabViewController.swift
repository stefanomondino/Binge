//
//  TabViewController.swift
//  App
//

import UIKit
import ViewModel
import Boomerang
import SnapKit
import RxSwift
import RxCocoa

class TabViewController: UITabBarController, WithScenePageConfiguration, ViewModelCompatible {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundImage = UIImage.navbar()
        self.tabBar.tintColor = .white
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    public func configure(with viewModel: TabViewModel) {
        self.boomerang.configure(with: viewModel)
        viewModel.load()
    }
    //    override open func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        var tabFrame = self.tabBar.frame
    //        tabFrame.size.height = kBarHeight
    //        tabFrame.origin.y = self.view.frame.size.height - kBarHeight
    //        self.tabBar.frame = tabFrame
    //    }
    //    public func configure(scene: (Scene & ViewModelCompatibleType), with viewModel: PageViewModelType ) -> Scene {
    //        //        let nav = NavigationController(rootViewController: scene)
    //        let vc = super.configure(scene: scene, with: viewModel)
    //        let nav =
    //        return nav
    //    }
    func configure(scene: (Scene & ViewModelCompatibleType), with viewModel: PageViewModelType) -> Scene {
        
        let nav = NavigationController(rootViewController: scene)
        viewModel.pageImage.asDriver(onErrorJustReturn: UIImage()).drive(nav.tabBarItem.rx.image).disposed(by: scene.disposeBag)
        viewModel.selectedPageImage.asDriver(onErrorJustReturn: UIImage()).drive(nav.tabBarItem.rx.selectedImage).disposed(by: scene.disposeBag)
        viewModel.pageTitle.asDriver(onErrorJustReturn: "").drive(nav.tabBarItem.rx.title).disposed(by: scene.disposeBag)
        return nav
        
    }
}
