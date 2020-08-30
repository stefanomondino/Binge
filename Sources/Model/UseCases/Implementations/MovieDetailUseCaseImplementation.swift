//
//  ShowDetailUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

public struct MovieDetailUseCaseImplementation: MovieDetailUseCase {
    let movies: MoviesRepository

    public func movieDetail(for movie: TraktItem) -> Observable<Trakt.Movie.Detail> {
        return
            Observable.combineLatest(movies.detail(forMovie: movie),
                                     movies.info(forMovie: movie)) { detail, info in
                var detail = detail
                detail.info = info
                return detail
            }
    }

    public func cast(for movie: TraktItem) -> Observable<[Trakt.CastMember]> {
        return movies.people(forMovie: movie)
            .map { $0.cast }
    }

    public func related(for movie: TraktItem) -> Observable<[TraktItemContainer]> {
        return movies.related(of: movie)
            .map { $0 }
    }

    public func fanart(for movie: TraktItem) -> Observable<FanartResponse> {
        return movies.fanart(for: movie)
    }
}
