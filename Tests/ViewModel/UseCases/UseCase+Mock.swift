//
//  UseCase+Mock.swift
//  ViewModelTests
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

protocol MockUseCase {
    mutating func configure<T> (with value:T, for keyPath: WritableKeyPath<Self,T>) -> Self
}
extension MockUseCase {
    mutating func configure<T> (with value:T, for keyPath: WritableKeyPath<Self,T>) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}
