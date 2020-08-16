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

    public func showDetail(for show: Show) -> Observable<ShowDetail> {
        return
            Observable.combineLatest(shows.detail(forShow: show),
                                     shows.info(forShow: show)) { detail, info in
                var detail = detail
                detail.info = info
                return detail
            }

//                .map { $0 }
    }

    public func cast(for show: Show) -> Observable<[CastMember]> {
        return shows.people(forShow: show)
            .map { $0.cast }
    }

    public func related(for show: Show) -> Observable<[WithShow]> {
        return shows.related(of: show)
            .map { $0 }
    }

    public func fanart(for show: Show) -> Observable<FanartResponse> {
        return shows.fanart(for: show)
    }
}
