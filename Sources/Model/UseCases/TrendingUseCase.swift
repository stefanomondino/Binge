
import Foundation
import RxSwift

public protocol TrendingUseCaseType {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[Show]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
}

public struct TrendingUseCase: TrendingUseCaseType {
    
    public func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
        return Repositories.shows.trending(currentPage: currentPage, pageSize: pageSize)
    }
    public func popular(currentPage: Int, pageSize: Int) -> Observable<[Show]> {
        return Repositories.shows.popular(currentPage: currentPage, pageSize: pageSize)
    }
    public func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return Repositories.shows.played(currentPage: currentPage, pageSize: pageSize)
    }
    public func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return Repositories.shows.watched(currentPage: currentPage, pageSize: pageSize)
    }
    public func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return Repositories.shows.collected(currentPage: currentPage, pageSize: pageSize)
    }
}
