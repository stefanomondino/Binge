//
//  StyleFactory.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Boomerang

protocol StyleFactory {
    func apply(_ style: Styles, to view: UIImageView)
    func apply(_ style: Styles, to view: UIView)
    func apply(_ style: Styles, to view: UILabel)
    func apply(_ style: Styles, to view: UIButton)
//    var container: AppDependencyContainer { get }
//    func detailRoute(show: Show) -> Route
}

class DefaultStyleFactory: StyleFactory, DependencyContainer {
    
    var container: Container<Styles> = Container()
    
    init(container: AppDependencyContainer) {
        self.register(for: .title) { TitleStyle() }
        self.register(for: .subtitle) { TitleStyle(size: 12) }
        self.register(for: .card) { CardStyle() }
    }
    
    func apply(_ style: Styles, to view: UIImageView) {
        
    }
    
    func apply(_ style: Styles, to view: UIButton) {
        
    }
    
    func apply(_ style: Styles, to label: UILabel) {
        let concrete: GenericStyle = self[style]
        label.style = concrete.style
    }
    func apply(_ style: Styles, to view: UIView) {
        let concrete: GenericStyle = resolve(style) ?? TitleStyle()
        view.backgroundColor = concrete.backgroundColor
        view.layer.cornerRadius = concrete.cornerRadius
    }
    
}
