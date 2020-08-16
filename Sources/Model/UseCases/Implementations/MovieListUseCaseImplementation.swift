//
//  MovieListUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

public class PopularMoviesUseCase: ItemListUseCase {
    public var page: PageInfo { .popular }

    let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]> {
        return repository
            .popular(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class TrendingMoviesUseCase: ItemListUseCase {
    public var page: PageInfo { .trending }

    let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]> {
        return repository
            .trending(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class WatchedMoviesUseCase: ItemListUseCase {
    public var page: PageInfo { .watched }

    let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]> {
        return repository
            .watched(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class CollectedMoviesUseCase: ItemListUseCase {
    public var page: PageInfo { .collected }

    let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]> {
        return repository
            .collected(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}

public class AnticipatedMoviesUseCase: ItemListUseCase {
    public var page: PageInfo { .anticipated }

    let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func items(currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]> {
        return repository
            .anticipated(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
}
