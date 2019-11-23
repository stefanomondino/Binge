
import Foundation
import RxSwift

public enum PageInfo {
    case popular
    case trending
}

public protocol ShowListUseCase {
    var page: PageInfo { get }
    func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]>
}

public class PopularShowsUseCase: ShowListUseCase {

    public var page: PageInfo { .popular }
    
    let repository: ShowsRepository
    
    init(repository: ShowsRepository) {
        self.repository = repository
    }
    
    public func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]> {
        return repository
                .popular(currentPage: currentPage, pageSize: pageSize)
                .map { $0 }
    }
}

public class TrendingShowsUseCase: ShowListUseCase {
    
    public var page: PageInfo { .trending }
    
    let repository: ShowsRepository
    
    init(repository: ShowsRepository) {
        self.repository = repository
    }
    
    public func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]> {
        return repository
                .trending(currentPage: currentPage, pageSize: pageSize)
                .map { $0 }
    }
}

//public struct DefaultShowListUseCase: ShowListUseCase {
//    let shows: ShowsRepository
//    public func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
//        return shows
//            .trending(currentPage: currentPage, pageSize: pageSize)
//    }
//    public func popular(currentPage: Int, pageSize: Int) -> Observable<[Show]> {
//        return shows
//            .popular(currentPage: currentPage, pageSize: pageSize)
//            .map { $0 }
//    }
//    public func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
//        return shows
//            .played(currentPage: currentPage, pageSize: pageSize)
//    }
//    public func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
//        return shows
//            .watched(currentPage: currentPage, pageSize: pageSize)
//    }
//    public func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
//        return shows.collected(currentPage: currentPage, pageSize: pageSize)
//    }
//}
