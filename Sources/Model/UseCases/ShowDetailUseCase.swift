import Foundation
import RxSwift

public protocol ShowDetailUseCase {
    func showDetail(for show: TraktItem) -> Observable<Trakt.Show.Detail>
    func cast(for show: TraktItem) -> Observable<[Trakt.CastMember]>
    func related(for show: TraktItem) -> Observable<[TraktItemContainer]>
    func fanart(for show: TraktItem) -> Observable<FanartResponse>
    func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> Observable<TMDB.Season.Info>
    func episodeDetail(for episode: Trakt.Episode, of show: TraktShowItem) -> Observable<TMDB.Season.Episode>
}
