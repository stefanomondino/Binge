//
//  ShowListUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

public class PopularShowsUseCase: ItemListUseCase {
    public var page: PageInfo { .popular }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[TraktItemContainer]> {
        return repository
            .popular(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class TrendingShowsUseCase: ItemListUseCase {
    public var page: PageInfo { .trending }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[TraktItemContainer]> {
        return repository
            .trending(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class WatchedShowsUseCase: ItemListUseCase {
    public var page: PageInfo { .watched }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[TraktItemContainer]> {
        return repository
            .watched(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class CollectedShowsUseCase: ItemListUseCase {
    public var page: PageInfo { .collected }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[TraktItemContainer]> {
        return repository
            .collected(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class AnticipatedShowsUseCase: ItemListUseCase {
    public var page: PageInfo { .anticipated }

    let repository: ShowsRepository

    init(repository: ShowsRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[TraktItemContainer]> {
        return repository
            .anticipated(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}
