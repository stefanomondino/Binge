
import Foundation
import RxSwift

public protocol ShowListUseCase {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[Show]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
}

public struct DefaultShowListUseCase: ShowListUseCase {
    let shows: ShowsRepository
    public func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
        return shows
            .trending(currentPage: currentPage, pageSize: pageSize)
    }
    public func popular(currentPage: Int, pageSize: Int) -> Observable<[Show]> {
        return shows
            .popular(currentPage: currentPage, pageSize: pageSize)
            .map { $0 }
    }
    public func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return shows
            .played(currentPage: currentPage, pageSize: pageSize)
    }
    public func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return shows
            .watched(currentPage: currentPage, pageSize: pageSize)
    }
    public func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return shows.collected(currentPage: currentPage, pageSize: pageSize)
    }
}
