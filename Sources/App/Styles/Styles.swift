//
//  Styles.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftRichString

protocol ContainerStyle {
    var backgroundColor: UIColor { get }
    var cornerRadius: CGFloat { get }
}

protocol TextStyle {
    var style: StyleProtocol { get }
}
