//
//  Core.swift
//  Core
//
//  Created by Stefano Mondino on 09/07/2020.
//

import Boomerang
import Foundation
import RxSwift
public typealias ObservableImage = Observable<Image>

public protocol WithImage {
    func getImage() -> ObservableImage
    func getImage(with placeholder: WithImage?) -> ObservableImage
}

extension WithImage {
    public func getImage() -> ObservableImage {
        return getImage(with: nil)
    }
}

public extension ViewModel {
    func unwrap<Supertype, DesiredType>(_ keyPath: KeyPath<Self, Supertype>, as _: DesiredType.Type) -> DesiredType? {
        return self[keyPath: keyPath] as? DesiredType
    }

    func `as`<DesiredType>(_: DesiredType.Type) -> DesiredType? {
        self as? DesiredType
    }
}
