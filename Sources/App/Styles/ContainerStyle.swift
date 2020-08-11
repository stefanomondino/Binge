//
//  ContainerStyle.swift
//  App
//
//  Created by Stefano Mondino on 24/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

struct DefaultContainerStyle: ContainerStyle {
    static var card: ContainerStyle {
        DefaultContainerStyle(cornerRadius: 4, backgroundColor: Color.white)
    }

    var cornerRadius: CGFloat = 0
    var backgroundColor: UIColor = .white
}
