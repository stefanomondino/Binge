//
//  UIViewController+Configuration.swift
//  App
//
//  Created by Stefano Mondino on 15/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Boomerang
import ViewModel
import RxGesture

extension SceneViewModelType {
    func setupViewController<T: UIViewController>() -> T? {
        guard let viewController = self.sceneIdentifier.scene() as? T else { return nil }
        (viewController as? (UIViewController & ViewModelCompatibleType))?.loadViewAndSet(viewModel: self)
        return viewController
    }
}

extension ViewModelCompatibleType where Self: UIViewController {
    func setup(with viewModel: ViewModelType) {
        (viewModel as? LoadingViewModelType)?
            .isLoading
            .asDriver(onErrorJustReturn: false)
            .drive (self.rx.toggleLoader())
            .disposed(by: self.disposeBag)
        
        if let self = self as? KeyboardAvoidable {
            self.setupKeyboardAvoiding()
            let tapConfiguration: TapConfiguration = { gesture, delegate in
                gesture.cancelsTouchesInView = false
                delegate.touchReceptionPolicy = .custom({ recognizer, touch in
                    return !(touch.view is UITextField || touch.view is TextPickerItemView || touch.view is UIButton)
                })
            }
            view.rx.tapGesture(configuration: tapConfiguration)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.view.endEditing(true)
                })
                .disposed(by: disposeBag)
        }
        if (self.navigationController?.children.count ?? 0 ) > 1 {
            let back = UIBarButtonItem(title: "Close", style: .done, target: nil, action: nil)
            back.rx.tap.bind { [weak self] in self?.navigationController?.popViewController(animated: true) }.disposed(by: disposeBag)
            self.navigationItem.leftBarButtonItem = back
        } else if self.presentingViewController != nil {
            let close = UIBarButtonItem(title: "Close", style: .done, target: nil, action: nil)
            close.rx.tap.bind { [weak self] in self?.dismiss(animated: true, completion: nil) }.disposed(by: self.disposeBag)
            self.navigationItem.leftBarButtonItem = close
        }
    }
}

extension ViewModelCompatible where Self: UIViewController {
    public func set(viewModel: ViewModelType) {
        if let viewModel = viewModel as? ViewModel {
            self.viewModel = viewModel
            setup(with: viewModel)
            self.configure(with: viewModel)
        }
    }
}
