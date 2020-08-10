//
//  Errors.swift
//  App
//
//  Created by Stefano Mondino on 15/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ConcreteError {
    var message: String { get }
}

public enum Errors: Error {
    case generic
    case notLogged
    case invalidUsername
    case invalidPassword
    case concrete(ConcreteError)
}
