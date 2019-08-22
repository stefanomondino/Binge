
import Foundation
import RxSwift

public protocol TrendingUseCaseType {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]>
}

public struct TrendingUseCase: TrendingUseCaseType {

    public func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
        return Repositories.shows.trending(currentPage: currentPage, pageSize: pageSize)
    }
}
