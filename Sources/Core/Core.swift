//
//  Core.swift
//  Core
//
//  Created by Stefano Mondino on 09/07/2020.
//

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
