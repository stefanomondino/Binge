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

extension Identifiers.Views: Bootstrappable {
    
    private var className: String {
        return self.rawValue.capitalizingFirstLetter() + "ItemView"
    }
    private var view: UIView? {
        return Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)?.first as? UIView
    }
    
    static func bootstrap() {
        self.allCases.forEach { item in
            ViewContainer.register(item) { () -> Identifiers.Views.Parameters in
                //This is the most basic Parameters configuration
                //For customization, switch on item and handle all required cases
                switch item {
                    default: return Parameters(shouldBeEmbedded: true) { item.view  }
                }
            }
        }
    }
}
