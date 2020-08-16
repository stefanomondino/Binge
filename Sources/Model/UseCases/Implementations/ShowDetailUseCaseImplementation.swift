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

    public func showDetail(for show: Item) -> Observable<ShowDetail> {
        return
            Observable.combineLatest(shows.detail(forShow: show),
                                     shows.info(forShow: show)) { detail, info in
                var detail = detail
                detail.info = info
                return detail
            }
    }

    public func cast(for show: Item) -> Observable<[CastMember]> {
        return shows.people(forShow: show)
            .map { $0.cast }
    }

    public func related(for show: Item) -> Observable<[ItemContainer]> {
        return shows.related(of: show)
            .map { $0 }
    }

    public func fanart(for show: Item) -> Observable<FanartResponse> {
        return shows.fanart(for: show)
    }
}
