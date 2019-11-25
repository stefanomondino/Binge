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
    
    let tmdb: TMDBDataSource
    let traktv: TraktTVDataSource

    func info(forShow show: Show) -> Observable<ShowInfo> {
        return tmdb.get(ShowInfo.self, at: .show(show))
    }
    func detail(forShow show: Show) -> Observable<ShowDetailItem> {
        return traktv.get(ShowDetailItem.self, at: .summary(show))
    }
    
     func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
        return traktv
            .get([TrendingShow].self,
                 at: .trending(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return traktv
            .get([PlayedShow].self, at: .played(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    
    func popular(currentPage: Int, pageSize: Int) -> Observable<[ShowItem]> {
        return traktv
            .get([ShowItem].self, at: .popular(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return traktv
            .get([PlayedShow].self, at: .watched(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return traktv
            .get([PlayedShow].self, at:
             .collected(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
}

