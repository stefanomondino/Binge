//
//  Router+ImagePicker.swift
//  App
//
//  Created by Stefano Mondino on 03/06/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxCocoa
import ViewModel

extension Router {
    static func setupImagePicker() {
        self.register(ImagePickerSelectionRoute.self) { route, scene in
            let optionMenu = UIAlertController(title: nil, message: Identifiers.Strings.chooseImage.translation, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: Identifiers.Strings.camera.translation, style: .default, handler: { _ in
                route.cameraAction()
            })
            
            let libraryAction = UIAlertAction(title: Identifiers.Strings.library.translation, style: .default, handler: { _ in
                route.libraryAction()
            })
            
            let cancelAction = UIAlertAction(title: Identifiers.Strings.cancel.translation, style: .cancel)
            
            optionMenu.addAction(cameraAction)
            optionMenu.addAction(libraryAction)
            optionMenu.addAction(cancelAction)
            
            scene?.present(optionMenu, animated: true, completion: nil)
        }
        self.register(SystemImagePickerRoute.self) { route, scene in
            let disposeBag = (scene as? UIViewController & ViewModelCompatibleType)?.disposeBag ?? DisposeBag()
            
            UIImagePickerController
                .rx
                .createWithParent(scene, animated: true, configureImagePicker: { picker in
                    /// Just for simulator purpose
                    if UIImagePickerController.isSourceTypeAvailable(.camera) ==  false {
                        picker.sourceType = .photoLibrary
                    } else {
                        picker.sourceType = route.viewModel.type == .camera ? .camera : .photoLibrary
                    }
                    
                    picker
                        .rx
                        .didFinishPickingMediaWithInfo
                        .map { dict in
                            return dict[UIImagePickerController.InfoKey.originalImage] as? UIImage
                        }
                        .map {
                            $0?.normalizedImage()
                        }
                        .take(1)
                        .do(onCompleted: {
                            picker.dismiss(animated: true, completion: nil)
                        })
                        .bind(to: route.viewModel.relay)
                        .disposed(by: disposeBag)
                })
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}
