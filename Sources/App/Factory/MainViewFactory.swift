//
//  ViewFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

enum ViewIdentifier: String, LayoutIdentifier {
    case show
    case header
    case loadMore
    var identifierString: String {
        return self.rawValue
    }
}

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

        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ItemView"
    }
}

