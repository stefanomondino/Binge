//
//  ContainerStyle.swift
//  App
//
//  Created by Stefano Mondino on 24/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

struct ContainerStyle: GenericStyle {
    
    let cornerRadius: CGFloat = 0
    
    var style: StyleProtocol?
    
    var backgroundColor: UIColor { return .background }
    
}
