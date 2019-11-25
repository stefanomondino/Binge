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

protocol TraktTVDataSource {
   func get<Result: Decodable>(_ type: Result.Type, at endpoint: TraktvAPI) -> Observable<Result>
}
protocol TMDBDataSource {
   func get<Result: Decodable>(_ type: Result.Type, at endpoint: TMDBAPI) -> Observable<Result>
}

//protocol TMDBDataSource {
//    func request(for parameters: TMDBAPI) -> Observable<Any>
//    func object<T: Codable>(for parameters: TMDBAPI) -> Observable<T>
//}

//private struct TraktTVMockDataSource: TraktTVDataSource {
//    func request(for parameters: API) -> Observable<Any> { return .empty() }
//    func object<T: ObjectType>(for parameters: API) -> Observable<T> { return .empty() }
//}

//public struct DataSources {
//    static var traktv: TraktTVDataSource = MoyaProvider<TraktvAPI>(plugins: [NetworkLoggerPlugin(verbose: Configuration.environment.debugEnabled, cURL: Configuration.environment.debugEnabled)])
//    static var tmdb: TMDBDataSource = MoyaProvider<TMDBAPI>(plugins: [NetworkLoggerPlugin(verbose: Configuration.environment.debugEnabled, cURL: Configuration.environment.debugEnabled)])
//}
