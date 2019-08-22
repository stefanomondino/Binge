//
//  Scenes+Dependency.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public struct ViewContainer: DependencyContainer {
    public static var container = Container<Int, Identifiers.Views.Parameters>()
    public typealias Value = Identifiers.Views.Parameters
//    public static var container = Container<Identifiers.Views,Value>()
}

//extension Identifiers.Views: DependencyKey {
//    public var keyValue: String {
//        return self.rawValue
//    }
//}

extension Identifiers.Views: ViewIdentifier {
    
    public struct Parameters {
        public var view: (() -> View?)
        public var shouldBeEmbedded: Bool = false
        public var containerClass: AnyClass?
        public var name: String?
        public init(name: String? = nil, shouldBeEmbedded: Bool = false, containerClass: AnyClass? = nil, view: @escaping (() -> View?)) {
            self.view = view
            self.name = name
            self.containerClass  = containerClass
            self.shouldBeEmbedded = shouldBeEmbedded
        }
    }
    
    public func view<T>() -> T? where T: View {
        return ViewContainer.resolve(self)?.view() as? T
    }
    
    public var shouldBeEmbedded: Bool {
        return ViewContainer.resolve(self)?.shouldBeEmbedded ?? true
    }
    
    public var containerClass: AnyClass? {
        return ViewContainer.resolve(self)?.containerClass
    }
    
    public var name: String {
        return ViewContainer.resolve(self)?.name ?? self.rawValue
    }
}
