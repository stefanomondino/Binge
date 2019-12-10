
import Foundation
import RxSwift

public protocol ShowDetailUseCaseType {
    func showDetail(for show: Show) -> Observable<ShowDetail>
    func cast(for show: Show) -> Observable<[CastMember]>
}

public struct ShowDetailUseCase: ShowDetailUseCaseType {

    let shows: ShowsRepository
    
    public func showDetail(for show: Show) -> Observable<ShowDetail> {
        return
            shows
            .detail(forShow: show)
            .map { $0 }
    }
    
    public func cast(for show: Show) -> Observable<[CastMember]> {
        return shows.people(forShow: show)
            .map { $0.cast }
    }
}
