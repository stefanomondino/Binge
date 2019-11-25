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

//protocol RESTDataSource {
//    associatedtype Endpoint
//    func get<Result: Decodable>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result>
//}
extension DefaultRESTDataSource: TraktTVDataSource where Endpoint == TraktvAPI {}
extension DefaultRESTDataSource: TMDBDataSource where Endpoint == TMDBAPI {}

class DefaultRESTDataSource<Endpoint: TargetType> {
    
    let provider: MoyaProvider<Endpoint>
    let jsonDecoder: JSONDecoder
    
    init(endpointType: Endpoint.Type,
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.provider = MoyaProvider<Endpoint>()
        self.jsonDecoder = jsonDecoder
    }
    
    func get<Result>(_ type: Result.Type, at endpoint: Endpoint) -> Observable<Result> where Result: Decodable {
        let decoder = self.jsonDecoder
            return response(at: endpoint)
                .map { try decoder.decode(Result.self, from: $0.data) }
    }
    
    private func response(at endpoint: Endpoint) -> Observable<Response> {
        return provider.rx
                   .request(endpoint)
                   .asObservable()
                   .filterSuccessfulStatusAndRedirectCodes()
                    
    }
}
