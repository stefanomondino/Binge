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
    
    let rest: RESTDataSource

    func info(forShow show: Show) -> Observable<ShowInfo> {
        return rest.get(ShowInfo.self, at: TMDBAPI.show(show))
    }
    func detail(forShow show: Show) -> Observable<ShowDetailItem> {
        return rest.get(ShowDetailItem.self, at: TraktvAPI.summary(show))
    }
    
     func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]> {
        return rest
            .get([TrendingShow].self,
                 at: TraktvAPI.trending(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return rest
            .get([PlayedShow].self, at: TraktvAPI.played(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    
    func popular(currentPage: Int, pageSize: Int) -> Observable<[ShowItem]> {
        return rest
            .get([ShowItem].self, at: TraktvAPI.popular(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return rest
            .get([PlayedShow].self, at: TraktvAPI.watched(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
    func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]> {
        return rest
            .get([PlayedShow].self, at:
             TraktvAPI.collected(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }
}

