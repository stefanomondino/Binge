//
//  RESTDataSource.swift
//  Model
//
//  Created by Stefano Mondino on 25/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Gloss
import Moya
import RxSwift

public typealias Response = Moya.Response

protocol JSONDecodable: Gloss.JSONDecodable {}
protocol TargetType: Moya.TargetType {
    var cacheKey: String { get }
    var parameters: [String: Any] { get }
}

class DefaultRESTDataSource: RESTDataSource, DependencyContainer {
    let container = Container<ObjectIdentifier>()
    let jsonDecoder: JSONDecoder
    let scheduler: SchedulerType
    required init(jsonDecoder: JSONDecoder = JSONDecoder(),
                  scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .utility)) {
        self.jsonDecoder = jsonDecoder
        self.scheduler = scheduler
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//
//        let cacheSize = 1024 * 1024 * 200
//        URLCache.shared = URLCache(memoryCapacity: cacheSize, diskCapacity: cacheSize, diskPath: nil)

        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: [.formatRequestAscURL, .verbose]))

        addProvider(MoyaProvider<TraktvAPI>(plugins: [networkLoggerPlugin]))
        addProvider(MoyaProvider<FanartAPI>(plugins: [networkLoggerPlugin]))
        addProvider(MoyaProvider<TMDBAPI>(plugins: [networkLoggerPlugin]))
    }

    func addProvider<Endpoint: TargetType>(_ provider: MoyaProvider<Endpoint>) {
        register(for: ObjectIdentifier(Endpoint.self),
                 scope: .singleton) { provider }
    }

    func request<Endpoint>(for endpoint: Endpoint) -> URLRequest? where Endpoint: TargetType {
        let provider = self.provider(for: Endpoint.self)
        return try? provider.endpoint(endpoint).urlRequest()
    }

    func provider<Endpoint: TargetType>(for _: Endpoint.Type) -> MoyaProvider<Endpoint> {
        guard let result: MoyaProvider<Endpoint> = resolve(ObjectIdentifier(Endpoint.self)) else {
            fatalError("No provider available")
        }
        return result
    }

    func get<Result, Endpoint>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result> where Result: Decodable, Endpoint: TargetType {
        response(at: endpoint).withDecodableMapping(type, decoder: jsonDecoder, scheduler: scheduler)
    }

    func get<Result, Endpoint>(_: Result.Type, at endpoint: Endpoint) -> Observable<Result> where Result: JSONDecodable, Endpoint: TargetType {
        return response(at: endpoint)
            .observeOn(scheduler)
            .mapObject(type: Result.self)
    }

    func get<Result, Endpoint>(_: Result.Type, at endpoint: Endpoint) -> Observable<[Result]> where Result: JSONDecodable, Endpoint: TargetType {
        return response(at: endpoint)
            .observeOn(scheduler)
            .mapArray(type: Result.self)
    }

    func response<Endpoint: TargetType>(at endpoint: Endpoint) -> Observable<Response> {
        return provider(for: Endpoint.self)
            .rx
            .request(endpoint)
            .asObservable()
            .withErrors()
    }
}

extension ObservableType where Self.Element == Response {
    func withErrors() -> Observable<Self.Element> {
        return filterSuccessfulStatusAndRedirectCodes()
    }

    func withDecodableMapping<Result>(_ type: Result.Type, decoder: JSONDecoder, scheduler: SchedulerType) -> Observable<Result> where Result: Decodable {
        return observeOn(scheduler)
            .map { try decoder.decode(type, from: $0.data) }
    }
}
