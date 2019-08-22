//
//  PassThroughView.swift
//  App
//
//  Created by Flavio Alescio on 28/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

class PassThroughView: UIView {
    
    var isPassThroughEnabled: Bool = true
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPassThroughEnabled
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return (view == self && isPassThroughEnabled) ? nil : view
    }
}
