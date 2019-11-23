//
//  StyleFactory.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

protocol StyleFactory {
    func apply(_ style: Styles, to view: UIImageView)
    func apply(_ style: Styles, to view: UIView)
    func apply(_ style: Styles, to view: UILabel)
    func apply(_ style: Styles, to view: UIButton)
}

class DefaultStyleFactory: StyleFactory, DependencyContainer {
    
    var container: Container<Styles> = Container()
    
    init(container: AppDependencyContainer) {
        self.register(for: .title) { TextStyle(size: 20) }
        self.register(for: .subtitle) { TextStyle(size: 12) }
        self.register(for: .card) { CardStyle() }
    }
    
    func apply(_ style: Styles, to view: UIImageView) {
        
    }
    
    func apply(_ style: Styles, to view: UIButton) {
        
    }
    
    func apply(_ style: Styles, to label: UILabel) {
        let concrete: GenericStyle = self[style]
        label.style = concrete.style
        label.numberOfLines = 0
    }
    func apply(_ style: Styles, to view: UIView) {
        let concrete: GenericStyle = self[style]
        view.backgroundColor = concrete.backgroundColor
        view.layer.cornerRadius = concrete.cornerRadius
        view.layer.masksToBounds = true
    }
}
