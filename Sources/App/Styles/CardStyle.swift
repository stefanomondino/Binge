//
//  CardStyle.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

struct CardStyle: GenericStyle {
    var style: StyleProtocol?
    var backgroundColor: UIColor { .white }
    let cornerRadius: CGFloat = 4
}
