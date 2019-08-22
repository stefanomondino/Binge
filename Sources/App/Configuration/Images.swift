//
//  Images.swift
//  App
//
//  Created by Stefano Mondino on 28/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import ViewModel

extension Identifiers.Images: Bootstrappable {
    static func bootstrap() {
        self.allCases.map { image -> (Identifiers.Images, Identifiers.Images.Parameters) in
            switch image {
                //case
            default: return (image, Parameters(name: image.rawValue))
            }
            }.forEach { t in
                ImageContainer.register(t.0, handler: { t.1 })
            }
        }
}
