//
//  SearchRepository.swift
//  Binge
//
//  Created by Stefano Mondino on 18/08/2020.
//

import Boomerang
import Foundation
import RxSwift

protocol SearchRepository {
    func search(query: String, currentPage: Int, pageSize: Int) -> Observable<[Search.SearchItem]>
}

struct SearchRepositoryImplementation: SearchRepository {
    let rest: RESTDataSource
    func search(query: String, currentPage: Int, pageSize: Int) -> Observable<[Search.SearchItem]> {
        rest
            .get([Search.ItemResponse].self, at: TraktvAPI.search(query, .init(page: currentPage, limit: pageSize)))
            .map { response in response.compactMap { $0.item } }
    }
}
