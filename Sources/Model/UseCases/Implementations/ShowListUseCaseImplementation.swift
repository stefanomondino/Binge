//
//  ShowListUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

public class PopularShowsUseCase: ShowListUseCase {
    public var page: PageInfo { .popular }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]> {
        return repository
            .popular(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class TrendingShowsUseCase: ShowListUseCase {
    public var page: PageInfo { .trending }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]> {
        return repository
            .trending(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class WatchedShowsUseCase: ShowListUseCase {
    public var page: PageInfo { .watched }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]> {
        return repository
            .watched(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}
