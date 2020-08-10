//
//  MockedRESTDataSource.swift
//  Model
//
//  Created by Stefano Mondino on 11/07/2020.
//

import Boomerang
import Foundation
import Gloss
import RxSwift

private extension String {
//    func jsonResponse(code: Int = 200, delay: TimeInterval = 0) -> MockDataSource.SampleResponse {
//        return .init(jsonMock(), statusCode: code, delay: delay)
//    }

    func jsonMock(from bundle: Bundle, fileExtension: String = "json") -> Data {
        if let path = bundle.url(forResource: self, withExtension: fileExtension),
            let contents = try? String(contentsOf: path),
            let data = contents.data(using: .utf8) {
            return data
        }

        fatalError("JSON File \(self).json not found in bundle")
    }

//    func json() -> [String: Any] {
//        return try! JSONSerialization.jsonObject(with: jsonMock(), options: []) as! [String: Any]
//    }
//
//    func jsonArray() -> [[String: Any]] {
//        return try! JSONSerialization.jsonObject(with: jsonMock(), options: []) as! [[String: Any]]
//    }
}

final class MockDataSource: RESTDataSource, DependencyContainer {
    fileprivate struct SampleResponse {
        let data: Data
        let statusCode: Int
        let delay: TimeInterval

        init(jsonPath: String, bundle: Bundle, statusCode: Int = 200) {
            self.init(jsonPath.jsonMock(from: bundle, fileExtension: "json"), statusCode: statusCode)
        }

        init(jsonString: String, statusCode: Int = 200) {
            self.init(jsonString.data(using: .utf8) ?? Data(), statusCode: statusCode)
        }

        init(_ data: Data, statusCode: Int = 200, delay: TimeInterval = 0) {
            self.data = data
            self.statusCode = statusCode
            self.delay = delay
        }

        fileprivate func toResponse() -> Response {
            Response(statusCode: statusCode, data: data, request: nil, response: nil)
        }
    }

    var container: Container<String> = Container()
    let jsonDecoder: JSONDecoder
    let scheduler: SchedulerType

    init(jsonDecoder: JSONDecoder = JSONDecoder(),
         scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .utility)) {
        self.jsonDecoder = jsonDecoder
        self.scheduler = scheduler
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func mockJSONString<Target>(_ jsonString: String, statusCode: Int = 200, for key: Target) where Target: Model.TargetType {
        let response = SampleResponse(jsonString.data(using: .utf8) ?? Data(), statusCode: statusCode)
        mock(response: response, for: key)
    }

    func mockJSONFile<Target>(_ path: String, bundle: Bundle, statusCode: Int = 200, for key: Target) where Target: Model.TargetType {
        let data = path.jsonMock(from: bundle)
        let response = SampleResponse(data, statusCode: statusCode)
        mock(response: response, for: key)
    }

    private func mock<Target>(response: SampleResponse, for key: Target) where Target: Model.TargetType {
        register(for: key.cacheKey, scope: .unique) { response.toResponse() }
    }

    func reset() {
        container = Container()
    }

//    func register<Target, Value>(for key: Target, scope _: Container<String>.Scope = .unique, handler: @escaping () -> Value) where Target: TargetType {
//        register(for: key.cacheKey, handler: handler)
//    }

    func resolve<Target, Value>(_ key: Target) -> Value? where Target: TargetType {
        return resolve(key.cacheKey)
    }

    func request<Endpoint>(for _: Endpoint) -> URLRequest? where Endpoint: TargetType {
        return nil
    }

    func get<Result, Endpoint>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result> where Result: Decodable, Result: Encodable, Endpoint: TargetType {
        //        guard let response: Response = self.resolve(endpoint) else { return .empty() }
        let response: Response? = resolve(endpoint)
        return Observable<Response>
            .just(response ?? Response(statusCode: 404, data: Data()))
            .withErrors()
            .withDecodableMapping(type, decoder: jsonDecoder, scheduler: scheduler)
    }

    func get<Result, Endpoint>(_: Result.Type, at _: Endpoint) -> Observable<Result> where Result: JSONDecodable, Endpoint: TargetType {
        return .empty()
    }

    func get<Result, Endpoint>(_: Result.Type, at _: Endpoint) -> Observable<[Result]> where Result: JSONDecodable, Endpoint: TargetType {
        return .empty()
    }
}
