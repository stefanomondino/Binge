//
//  UserPropertyDataSource.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Foundation

protocol UserPropertyDataSource: AnyObject {
    var selectedThemeId: String { get set }
}
