//
//  RESTDataSource.swift
//  Model
//
//  Created by Stefano Mondino on 25/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Boomerang
import Gloss

protocol RESTDataSource {
    func request<Endpoint: TargetType>(for endpoint: Endpoint) -> URLRequest?
    func get<Result: Codable, Endpoint: TargetType>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result>
    func get<Result: JSONDecodable, Endpoint: TargetType>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result>
    func get<Result: JSONDecodable, Endpoint: TargetType>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<[Result]>
}

class DefaultRESTDataSource: RESTDataSource, DependencyContainer {
    
    let container = Container<ObjectIdentifier>()
    let jsonDecoder: JSONDecoder
    let scheduler: SchedulerType
    init(jsonDecoder: JSONDecoder = JSONDecoder(),
         scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .utility)) {
        self.jsonDecoder = jsonDecoder
        self.scheduler = scheduler
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let cacheSize = 1024 * 1024 * 200
        URLCache.shared = URLCache(memoryCapacity: cacheSize, diskCapacity: cacheSize, diskPath: nil)
        
        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: [.formatRequestAscURL, .verbose]))
        
        self.register(for: ObjectIdentifier(TraktvAPI.self),
                      scope: .singleton) {
                        MoyaProvider<TraktvAPI>(plugins: [networkLoggerPlugin])
        }
        
        self.register(for: ObjectIdentifier(TMDBAPI.self),
                      scope: .singleton) {
                        MoyaProvider<TMDBAPI>(plugins: [networkLoggerPlugin])
        }
    }
    
    func request<Endpoint>(for endpoint: Endpoint) -> URLRequest? where Endpoint : TargetType {
        let provider = self.provider(for: Endpoint.self)
        return try? provider.endpoint(endpoint).urlRequest()
    }
    func provider<Endpoint: TargetType>(for type: Endpoint.Type) -> MoyaProvider<Endpoint> {
        guard let result: MoyaProvider<Endpoint> = self.resolve(ObjectIdentifier(Endpoint.self)) else {
            fatalError("No provider available")
        }
        return result
    }
    
    func get<Result, Endpoint>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result> where Result: Decodable, Endpoint: TargetType {
        let decoder = self.jsonDecoder
        return response(at: endpoint)
            .observeOn(scheduler)
            .map { try decoder.decode(Result.self, from: $0.data) }
    }
    func get<Result, Endpoint>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result> where Result: JSONDecodable, Endpoint: TargetType {
        return response(at: endpoint)
            .observeOn(scheduler)
            .mapObject(type: Result.self)
    }
    
    func get<Result, Endpoint>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<[Result]> where Result: JSONDecodable, Endpoint: TargetType {
        return response(at: endpoint)
            .observeOn(scheduler)
            .mapArray(type: Result.self)
    }
    private func response<Endpoint: TargetType>(at endpoint: Endpoint) -> Observable<Response> {
        return provider(for: Endpoint.self).rx
            .request(endpoint)
            .asObservable()
            .filterSuccessfulStatusAndRedirectCodes()
        
    }
}
