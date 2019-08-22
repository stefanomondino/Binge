//
//  Scenes.swift
//  App
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import ViewModel

extension Identifiers.Scenes: Bootstrappable {
    
    private var className: String {
        return self.rawValue.capitalizingFirstLetter() + "ViewController"
    }
    
    private var xibClass: UIViewController.Type? {
        
        switch self {
        
        default :
            let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
            return NSClassFromString(bundleName + "." + className) as? UIViewController.Type
        }
    }
    
    private var viewController: UIViewController? {
    
        if let xibClass = xibClass {
            return xibClass.init(nibName: self.className, bundle: nil)
        }
        return nil
    }
    
    static func bootstrap() {
        self.allCases.forEach { item in
            SceneContainer.register(item) { 
                Parameters(scene: { item.viewController })
            }
        }
    }
}
