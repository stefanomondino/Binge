//
//  Styles.swift
//  App
//
//  Created by Alberto Bo on 12/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public extension Identifiers {
    
    public enum Styles: String, CaseIterable, DependencyKey {
        
        case mainRegularStyle
        case mainBoldStyle
        case navbarTitle
        case placeholderBig
        case placeholderSmall
        case errorText
        case mainButton
        case mainFilledButton
        case mainEmptyButton
    }
}
