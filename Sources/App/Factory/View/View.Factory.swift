//
//  ViewFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import UIKit

class MainViewFactory: ViewFactory {
    let styleFactory: StyleFactory
    init(styleFactory: StyleFactory) {
        self.styleFactory = styleFactory
    }

    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        return nib(from: itemIdentifier)?
            .instantiate(withOwner: nil, options: nil)
            .first as? UIView
//         return (view as? UIView & WithStyle)?.withStyleFactory(styleFactory) ?? view
    }

    func nib(from itemIdentifier: LayoutIdentifier) -> UINib? {
        return UINib(nibName: name(from: itemIdentifier), bundle: nil)
    }

    func name(from itemIdentifier: LayoutIdentifier) -> String {
        let identifier = itemIdentifier.identifierString
        switch itemIdentifier {
//        case is ShowIdentifier: return identifier
        default: return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ItemView"
        }
    }
}
