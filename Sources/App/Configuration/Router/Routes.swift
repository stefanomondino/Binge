//
//  Routes.swift
//  App
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import ViewModel
import UIKit

extension Router: Bootstrappable {
    static func bootstrap() {
        setupImagePicker()
        self.register(RestartRoute.self) { route, _ in
           let vc = route.viewModel.setupViewController()
            let destination: UIViewController? =
                route.hasNavigation ? vc?.embedded() : vc
            UIApplication.shared.delegate?.window??.rootViewController = destination
        }
        
        self.register(NavigationRoute.self) { route, scene in
            if let destination = route.viewModel.setupViewController() {
                scene?.navigationController?.pushViewController(destination, animated: true)
            }
        }
        self.register(LoginRoute.self) { (route, _) in
             UIApplication.shared.delegate?.window??.rootViewController = route.viewModel.setupViewController()?.embedded()
        }
        
        self.register(ErrorRoute.self) { route, scene in
            let alert = UIAlertController(title: nil, message: route.error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Identifiers.Strings.ok.translation, style: .cancel, handler: nil))
            scene?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func restart() {
        self.execute(RestartRoute(), from: nil)
    }
}
