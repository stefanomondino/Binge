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
    func apply(_ style: Styles, to view: PagerButton)
}

class DefaultStyleFactory: DependencyContainer {
    
    var container: Container<Styles> = Container()
    
    init(container: AppDependencyContainer) {
        self.register(for: .container) { ContainerStyle() }
        self.register(for: .title) { TextStyle(size: 14) }
        self.register(for: .subtitle) { TextStyle(size: 12) }
        self.register(for: .card) { CardStyle() }
    }
}
extension DefaultStyleFactory: StyleFactory {
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
    func apply(_ style: Styles, to view: PagerButton) {
        view.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        view.tintColor = .darkGray
                    //            button.font = Fonts.special(.regular).font(size: 20)
        //            button.font = Fonts.main(.bold).font(size: 16)
        view.selectedTintColor = .black
    }
}
