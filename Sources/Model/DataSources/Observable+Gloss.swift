//
//  Observable+Gloss.swift
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers
//

import RxSwift
import Moya
import Gloss

/// Extension for transforming Moya Responses into Decodable object(s) via Gloss with Rx goodness
public extension ObservableType where Element == Response {
 
    /// Maps nested response data into an Observable of a type that implements the Decodable protocol.
    /// Observable .Errors's on failure.
    func mapObject<T: JSONDecodable>(type: T.Type, forKeyPath keyPath: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            if let keyPath = keyPath {
                return Observable.just(try response.mapObject(T.self, forKeyPath: keyPath))
            } else {
                return Observable.just(try response.mapObject(T.self))
            }
        }
    }

    /// Maps nested response data into an Observable of an array of a type that implements the Decodable protocol.
    /// Observable .Errors's on failure.
    func mapArray<T: JSONDecodable>(type: T.Type, forKeyPath keyPath: String? = nil) -> Observable<[T]> {
        return flatMap { (response) -> Observable<[T]> in
            if let keyPath = keyPath {
                return Observable.just(try response.mapArray(T.self, forKeyPath: keyPath))
            } else {
                return Observable.just(try response.mapArray(T.self))
            }
        }
    }
}

//Optional return value
public extension ObservableType where Element == Response {
    func mapObject<T: JSONDecodable>(type: T.Type) -> Observable<T?> {
        return flatMap { response -> Observable<T?> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
}
