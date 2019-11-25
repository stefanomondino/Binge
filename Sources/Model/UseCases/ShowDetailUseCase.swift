
import Foundation
import RxSwift

public protocol ShowDetailUseCaseType {
    func showDetail(for show: Show) -> Observable<ShowDetail>
}

public struct ShowDetailUseCase: ShowDetailUseCaseType {

    let shows: ShowsRepository
    
    public func showDetail(for show: Show) -> Observable<ShowDetail> {
        return
            shows
            .detail(forShow: show)
            .map { $0 }
    }
}
