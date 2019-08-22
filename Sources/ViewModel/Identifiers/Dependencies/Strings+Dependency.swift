//
//  Scenes+Dependency.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model

public struct StringsContainer: DependencyContainer {
    public static var container = Container<Int, Identifiers.Strings.Parameters>()
}

extension Identifiers.Strings: CustomStringConvertible {
    public var description: String {
        return translation
    }
    
    public struct Parameters {
        public var translation: String
        public init(translation: String) {
            self.translation = translation
        }
    }
    
    public var translation: String {
        return StringsContainer.resolve(self)?.translation ?? ""
    }
}
