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
    func search(query: String, currentPage: Int, pageSize: Int) -> Observable<[Trakt.Search.SearchItem]>
}

struct SearchRepositoryImplementation: SearchRepository {
    let rest: RESTDataSource
    func search(query: String, currentPage: Int, pageSize: Int) -> Observable<[Trakt.Search.SearchItem]> {
        rest
            .get([Trakt.Search.ItemResponse].self, at: Trakt.API.search(query, .init(page: currentPage, limit: pageSize)))
            .map { response in response
                .compactMap { $0.item }
                .filter { $0.item.ids.tmdb != nil }
            }
    }
}
