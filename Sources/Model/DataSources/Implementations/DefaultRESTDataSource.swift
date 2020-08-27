//
//  RESTDataSource.swift
//  Model
//
//  Created by Stefano Mondino on 25/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Alamofire
import Boomerang
import Core
import Foundation
import Gloss
import Moya
import RxSwift

public typealias Response = Moya.Response

protocol JSONDecodable: Gloss.JSONDecodable {}
protocol TargetType: Moya.TargetType {
    var cacheKey: String { get }
    var cacheTime: TimeInterval { get }
    var parameters: [String: Any] { get }
}

class DefaultRESTDataSource: RESTDataSource, DependencyContainer {
    let container = Container<ObjectIdentifier>()
    let jsonDecoder: JSONDecoder
    let scheduler: SchedulerType
    var urlCache: URLCache = .shared
    private var urlRequestCache: [URLRequest: Observable<Response>] = [:]

    required init(jsonDecoder: JSONDecoder = JSONDecoder(),
                  scheduler: SchedulerType = Scheduler.background) {
        self.jsonDecoder = jsonDecoder
        self.scheduler = scheduler
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //
        //        let cacheSize = 1024 * 1024 * 200
        //        URLCache.shared = URLCache(memoryCapacity: cacheSize, diskCapacity: cacheSize, diskPath: nil)
    }

    func addProvider<Endpoint: TargetType>(for _: Endpoint.Type) {
        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: .init(
            output: { _, items in items.forEach { Logger.log($0, level: .verbose, tag: .api) } },
            logOptions: [.verbose]
        ))
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        configuration.headers = .default
        let session = Alamofire.Session(configuration: configuration, startRequestsImmediately: false)
        addProvider(MoyaProvider<Endpoint>(session: session, plugins: [networkLoggerPlugin]))
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
        return Observable.deferred {
            let provider = self.provider(for: Endpoint.self)
            let request = try provider.endpoint(endpoint).urlRequest()
            if
                let running = self.urlRequestCache[request]
            {
                return running
            }

            let observable = provider
                .rx
                .request(endpoint)
                .asObservable()
                .withErrors()
                .observeOn(Scheduler.background)
                .do(onDispose: { [weak self] in self?.urlRequestCache[request] = nil })
                .share()
            self.urlRequestCache[request] = observable
            return observable
        }.subscribeOn(Scheduler.background)
    }
}

extension ObservableType where Self.Element == Response {
    func withErrors() -> Observable<Self.Element> {
        return filterSuccessfulStatusAndRedirectCodes()
    }

    func withDecodableMapping<Result>(_ type: Result.Type, decoder: JSONDecoder, scheduler: SchedulerType) -> Observable<Result> where Result: Decodable {
        return observeOn(scheduler)
            .map {
                do {
                    return try decoder.decode(type, from: $0.data)
                } catch {
                    Logger.log(error, level: .error)
                    throw error
                }
            }
    }
}
