import Foundation
import RxSwift

public protocol ShowDetailUseCase {
    func showDetail(for show: Show) -> Observable<ShowDetail>
    func cast(for show: Show) -> Observable<[CastMember]>
    func related(for show: Show) -> Observable<[WithShow]>
    func fanart(for show: Show) -> Observable<FanartResponse>
}
