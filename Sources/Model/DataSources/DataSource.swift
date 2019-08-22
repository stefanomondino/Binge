//
//  DataSource.swift
//  Model
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Moya

public protocol DataSourceParameters {
    var cacheKey: String { get }
}

// Entity objects are codable by default. Change this for custom cases (eg: when Codable is not suitable and Gloss is better for object Mapping)
// Please keep in mind that all standard datasource implementations are based on Codable: changing base type will require heavy refactoring.
public typealias ObjectType = Codable

protocol TraktTVDataSource {
    func request(for parameters: TraktvAPI) -> Observable<Any>
    func object<T: ObjectType>(for parameters: TraktvAPI) -> Observable<T>
}

//private struct TraktTVMockDataSource: TraktTVDataSource {
//    func request(for parameters: API) -> Observable<Any> { return .empty() }
//    func object<T: ObjectType>(for parameters: API) -> Observable<T> { return .empty() }
//}

public struct DataSources {
    static var traktv: TraktTVDataSource = MoyaProvider<TraktvAPI>(plugins: [NetworkLoggerPlugin(verbose: Configuration.environment.debugEnabled, cURL: Configuration.environment.debugEnabled)])
}
