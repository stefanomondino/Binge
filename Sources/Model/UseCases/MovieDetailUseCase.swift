import Foundation
import RxSwift

public protocol MovieDetailUseCase {
    func movieDetail(for movie: TraktItem) -> Observable<Trakt.Movie.Detail>
    func cast(for movie: TraktItem) -> Observable<[Trakt.CastMember]>
    func related(for movie: TraktItem) -> Observable<[TraktItemContainer]>
    func fanart(for movie: TraktItem) -> Observable<FanartResponse>
}
