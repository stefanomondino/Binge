import Foundation
import RxSwift

public protocol MovieDetailUseCase {
    func movieDetail(for movie: Item) -> Observable<MovieDetail>
    func cast(for movie: Item) -> Observable<[CastMember]>
    func related(for movie: Item) -> Observable<[ItemContainer]>
    func fanart(for movie: Item) -> Observable<FanartResponse>
}
