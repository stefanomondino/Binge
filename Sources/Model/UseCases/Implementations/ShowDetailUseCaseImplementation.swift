//
//  ShowDetailUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

public struct ShowDetailUseCaseImplementation: ShowDetailUseCase {
    let shows: ShowsRepository

    public func showDetail(for show: TraktItem) -> Observable<Trakt.Show.Detail> {
        return
            Observable.combineLatest(shows.detail(forShow: show),
                                     shows.info(forShow: show)) { detail, info in
                var detail = detail
                detail.info = info
                return detail
            }
    }

    public func cast(for show: TraktItem) -> Observable<[Trakt.CastMember]> {
        return shows.people(forShow: show)
            .map { $0.cast }
    }

    public func related(for show: TraktItem) -> Observable<[TraktItemContainer]> {
        return shows.related(of: show)
            .map { $0 }
    }

    public func fanart(for show: TraktItem) -> Observable<FanartResponse> {
        return shows.fanart(for: show)
    }

    public func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> Observable<TMDB.Season.Info> {
        shows.seasonDetail(for: season, of: show)
    }

    public func episodeDetail(for episode: Trakt.Episode, of show: TraktShowItem) -> Observable<TMDB.Season.Episode> {
        shows.info(for: episode, of: show)
    }
}
