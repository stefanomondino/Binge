//
//  UIImagePickerController+Rx.swift
//  App
//
//  Created by Stefano Mondino on 06/06/18.
//  Copyright © 2018 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Boomerang

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension UIImage {
    func normalizedImage() -> UIImage? {
        
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}

extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            do {
                try configureImagePicker(imagePicker)
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }
}

#if os(iOS)

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImagePickerController {
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}

#endif

#if os(iOS)

import RxSwift
import RxCocoa
import UIKit

open class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
    
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
    
}
#endif
private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
