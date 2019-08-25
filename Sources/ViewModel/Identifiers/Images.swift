//
//  Images.swift
//  ViewModel
//
//  Created by Stefano Mondino on 28/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
extension Identifiers {
    public enum Images: String, CaseIterable, DependencyKey {
        case appIcon
        case eyePassword
        case eyePasswordSelected
        case cancelTextField
        
        case tabShows
        
        public var image: UIImage {
            
            if let image = UIImage(named: self.name) {
                return image
            }
            Logger.log("\(self.rawValue) not found in asssets", level: .error, tag: "IMAGES")
            return UIImage()
        }
    }
}
