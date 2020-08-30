//
//  RESTDataSource.swift
//  Core
//
//  Created by Stefano Mondino on 27/07/2020.
//

import Foundation
import RxSwift

protocol RESTDataSource {
    init(jsonDecoder: JSONDecoder, scheduler: SchedulerType)
    func request<Endpoint: TargetType>(for endpoint: Endpoint) -> URLRequest?
    func get<Result: Codable, Endpoint: TargetType>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result>
    func get<Result: JSONDecodable, Endpoint: TargetType>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result>
    func get<Result: JSONDecodable, Endpoint: TargetType>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<[Result]>
}

struct EmptyResource: Codable {}
extension TargetType {
    var cacheKey: String {
        return [baseURL.absoluteString, path, method.rawValue, parameters
            .map { [$0.key, ($0.value as? CustomStringConvertible)?.description].compactMap { $0 }.joined(separator: "_") }
            .sorted()
            .joined()].joined()
    }
}
