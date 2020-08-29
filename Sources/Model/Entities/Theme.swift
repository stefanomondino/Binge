//
//  Theme.swift
//  BingeTests_iOS
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Foundation

public protocol Theme {
    var name: String { get }
    var identifier: String { get }
    func setup()
}
