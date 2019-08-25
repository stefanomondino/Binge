
import Foundation
import RxSwift

public protocol ShowDetailUseCaseType {
    func showDetail(for show: Show) -> Observable<ShowDetail>
}

public struct ShowDetailUseCase: ShowDetailUseCaseType {

    public func showDetail(for show: Show) -> Observable<ShowDetail> {
        return Repositories
            .shows
            .detail(forShow: show)
            .map { $0 }
    }
}
