//
//  Bootstrap.swift
//  App
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import ViewModel

protocol Bootstrappable {
    static func bootstrap()
}

enum Bootstrappables: Bootstrappable, CaseIterable {
    case app
    case views
    case scenes
    case images
    case strings
    case router
    
    private var bootstrappable: Bootstrappable.Type {
        switch self {
        case .views: return Identifiers.Views.self
        case .scenes: return Identifiers.Scenes.self
        case .images: return Identifiers.Images.self
        case .strings: return Identifiers.Strings.self
        case .router: return Router.self
        case .app: return Environment.self
        }
    }
    static func bootstrap() {
        self.allCases.forEach { $0.bootstrappable.bootstrap() }
        Router.restart()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
