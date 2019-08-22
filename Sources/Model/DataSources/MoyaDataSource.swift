//
//  Moya+Provider.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Boomerang
import Gloss

private struct MoyaDataProviderParameters<Target: TargetType> {
    let target: Target
    let keyPath: String?
    let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
}

//DUPLICATE THIS EXTENSION FOR EACH TARGET TYPE
extension MoyaProvider: TraktTVDataSource where Target ==  TraktvAPI {
    
    func request(for parameters: Target) -> Observable<Any> {
        let p: DataSourceParameters = parameters
        let o: Observable<Any> = self.object(for: p)
        return o
    }
    
    func object<T>(for parameters: Target) -> Observable<T> where T: Decodable {
        let p: DataSourceParameters = parameters
        let o: Observable<T> = self.object(for: p)
        return o
    }
    
    func object<T>(for parameters: Target) -> Observable<T> where T: JSONDecodable {
        let p: DataSourceParameters = parameters
        let o: Observable<T> = self.object(for: p)
        return o
    }
    
    func object<T>(for parameters: Target) -> Observable<[T]> where T: JSONDecodable {
        let p: DataSourceParameters = parameters
        let o: Observable<[T]> = self.object(for: p)
        return o
    }
}

fileprivate extension DataSourceParameters {
    func moyaParameters<Target: TargetType>() -> MoyaDataProviderParameters<Target>? {
        guard let parameters = self as? Target else {
            Logger.log("Provided DataSourceParameters are not compatible with current datasource", level: .verbose)
            return nil
        }
        return MoyaDataProviderParameters(target: parameters, keyPath: nil)
    }
}
extension MoyaProvider {
    public func object(for parameters: DataSourceParameters) -> Observable<Any> {
        
        guard let request: MoyaDataProviderParameters<Target> = parameters.moyaParameters() else { return .empty() }
        return self.rx
            .modelRequest(request)
            .asObservable()
            .observeOn(Scheduler.background)
            .map { $0 }
    }
    func object<T: Decodable>(for parameters: DataSourceParameters) -> Observable<T> {
        guard let request: MoyaDataProviderParameters<Target> = parameters.moyaParameters() else { return .empty() }
        let response: Observable<Response> = object(for: parameters).flatMap { Observable.from(optional: $0 as? Response)}
        return response
            .map(T.self, atKeyPath: request.keyPath, using: request.decoder, failsOnEmptyData: false)
            .do(onError: {
                Logger.log($0.localizedDescription, level: .verbose)
            })
    }
    
    func object<T: JSONDecodable>(for parameters: DataSourceParameters) -> Observable<T> {
        guard let request: MoyaDataProviderParameters<Target> = parameters.moyaParameters() else { return .empty() }
        let response: Observable<Response> = object(for: parameters).flatMap { Observable.from(optional: $0 as? Response)}
        return response
            .mapObject(type: T.self, forKeyPath: request.keyPath)
            .do(onError: {
                Logger.log($0.localizedDescription, level: .verbose)
            })
    }
    func object<T: JSONDecodable>(for parameters: DataSourceParameters) -> Observable<[T]> {
        guard let request: MoyaDataProviderParameters<Target> = parameters.moyaParameters() else { return .empty() }
        let response: Observable<Response> = object(for: parameters).flatMap { Observable.from(optional: $0 as? Response)}
        return response
            .mapArray(type: T.self, forKeyPath: request.keyPath)
            .do(onError: {
                Logger.log($0.localizedDescription, level: .verbose)
            })
    }
}

extension Reactive where Base: MoyaProviderType {
    fileprivate func modelRequest(_ parameters: MoyaDataProviderParameters<Base.Target>) -> Observable<Moya.Response> {
        return request(parameters.target)
            .asObservable()
            .filterSuccessfulStatusAndRedirectCodes()
    }
}
