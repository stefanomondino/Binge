import Foundation
import RxSwift

public protocol ShowDetailUseCase {
    func showDetail(for show: Item) -> Observable<ShowDetail>
    func cast(for show: Item) -> Observable<[CastMember]>
    func related(for show: Item) -> Observable<[ItemContainer]>
    func fanart(for show: Item) -> Observable<FanartResponse>
}
