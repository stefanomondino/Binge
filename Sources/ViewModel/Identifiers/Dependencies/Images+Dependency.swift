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
public struct ImageContainer: DependencyContainer {
    public static var container = Container<Int, Identifiers.Images.Parameters>()
}

extension Identifiers.Images: WithImage, Hashable {

    public struct Parameters {
        public var name: String
        public init(name: String) {
            self.name = name
        }
    }
    
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return name.getImage()
    }
    
    public var name: String {
        return ImageContainer.resolve(self)?.name ?? rawValue
    }
}
