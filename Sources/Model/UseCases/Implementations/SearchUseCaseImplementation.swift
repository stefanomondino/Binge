//
//  ShowListUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

class SearchUseCaseImplementation: SearchUseCase {
    var page: PageInfo { .popular }

    let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func items(query: String, currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]> {
        return repository
            .search(query: query, currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}
