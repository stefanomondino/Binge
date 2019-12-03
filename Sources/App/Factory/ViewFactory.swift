//
//  ViewFactory.swift
//  App
//
//  Created by Stefano Mondino on 03/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Core

public class DefaultViewFactory: ViewFactory {
//    let styleFactory: StyleFactory
//    init(styleFactory: StyleFactory) {
//        self.styleFactory = styleFactory
//    }
    public init() {

    }
    public func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        return nib(from: itemIdentifier)?
        .instantiate(withOwner: nil, options: nil)
        .first as? UIView
//         return (view as? UIView & WithStyle)?.withStyleFactory(styleFactory) ?? view
    }

    func nib(from itemIdentifier: LayoutIdentifier) -> UINib? {
        let bundle: Bundle?
        switch itemIdentifier {
        case is ItemViewIdentifier: bundle =  nil
        case is ViewIdentifier: bundle = Bundle(for: DefaultCoreDependencyContainer.self)
        default: bundle = nil
        }
        
        return UINib(nibName: name(from: itemIdentifier), bundle: bundle)
    }

    public func name(from itemIdentifier: LayoutIdentifier) -> String {
        let identifier = itemIdentifier.identifierString

        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ItemView"
    }
}
