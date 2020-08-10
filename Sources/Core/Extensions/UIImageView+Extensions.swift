//
//  UIImageView+Extensions.swift
//  App
//
//  Created by Stefano Mondino on 16/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
    import RxCocoa
    import RxSwift
    import UIKit

    public extension UIImageView {
        func animatedImage(_ image: UIImage?) {
            if image?.isDownloaded == false {
                self.image = image
                return
            }
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in self?.image = image },
                              completion: nil)
        }
    }

    public extension Reactive where Base: UIImageView {
        func animatedImage() -> Binder<UIImage?> {
            return Binder(base) { base, image in
                base.animatedImage(image)
            }
        }
    }
#endif
