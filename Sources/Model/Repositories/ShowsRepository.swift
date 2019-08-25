import Foundation
import Boomerang
import RxSwift
import Moya

 protocol ShowsRepository {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[ShowItem]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
     func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
     func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    
    func info(forShow show: Show) -> Observable<ShowInfo>
    func detail(forShow show: Show) -> Observable<ShowDetailItem>
}

 struct ShowsAPIRepository: ShowsRepository {
    
    func info(forShow show: Show) -> Observable<ShowInfo> {
        return DataSources.tmdb.object(for: .show(show))
    }
    func detail(forShow show: Show) -> Observable<ShowDetailItem> {
        return DataSources.traktv.object(for: .summary(show))
    }
    
     func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
        return DataSources
            .traktv
            .object(for: .trending(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return DataSources
            .traktv
            .object(for: .played(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    
    func popular(currentPage: Int, pageSize: Int) -> Observable<[ShowItem]> {
        return DataSources
            .traktv
            .object(for: .popular(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return DataSources
            .traktv
            .object(for: .watched(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return DataSources
            .traktv
            .object(for: .collected(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
}

