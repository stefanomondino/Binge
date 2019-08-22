//
//  MockDataSource.swift
//  App
//
//  Created by Stefano Mondino on 11/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Boomerang
@testable import Model

/// dummy class used to reference current bundle
private class TestEnvironment {}

extension String {
    
    func jsonResponse(code: Int = 200, delay: TimeInterval = 0) -> SampleResponse {
        return SampleResponse(jsonMock(), statusCode: code, delay: delay)
    }
    
    func jsonMock() -> Data {
        if let path =  Bundle.init(for: TestEnvironment.self).url(forResource: self, withExtension: "json"),
            let contents = try? String(contentsOf: path),
            let data = contents.data(using: .utf8) {
            return data
        }
        
        fatalError("JSON File \(self).json not found in bundle")
    }
    func json() -> [String: Any] {
        return try! JSONSerialization.jsonObject(with: self.jsonMock(), options: []) as! [String: Any]
    }
    func jsonArray() -> [[String: Any]] {
        return try! JSONSerialization.jsonObject(with: self.jsonMock(), options: []) as! [[String: Any]]
    }
}

struct APIContainer: DependencyContainer {
    typealias Value = SampleResponse
    static var container: Container<Int, Value> = Container()
}

extension DataSourceParameters {
    var mockResponse: SampleResponse? {
        return APIContainer.resolve(self)
    }
}

struct SampleResponse {
    let data: Data
    let statusCode: Int
    let delay: TimeInterval
    
    init (_ data: Data, statusCode: Int = 200, delay: TimeInterval = 0) {
        self.data = data
        self.statusCode = statusCode
        self.delay = delay
    }
}

class MockDataSource<P: DataSourceParameters & TargetType>: MoyaProvider<P> {
    convenience init() {
        let endpointClosure = { (target:P) -> Moya.Endpoint in
            return Moya.Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: {
                    let response = target.mockResponse
                    return EndpointSampleResponse.networkResponse(response?.statusCode ?? 200, response?.data ?? Data())
            },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        self.init(
        endpointClosure: endpointClosure,
        stubClosure: { target -> StubBehavior in
            return StubBehavior.delayed(seconds: target.mockResponse?.delay ?? 0)
        })
    }
}

