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

extension Identifiers.Strings: Bootstrappable {
    static func bootstrap() {
        self.allCases.forEach { t in
            StringsContainer.register(t, handler: { Parameters(translation: self.translation(for: t)) })
        }
    }
    
    static func translation(for string: Identifiers.Strings) -> String {
        switch string {
            //Define here how strings should be localized
            
        default: return Environment.current.vocabulary[string.rawValue] ?? string.rawValue
        }
    }
}
