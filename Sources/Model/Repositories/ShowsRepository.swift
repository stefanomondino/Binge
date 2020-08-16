import Boomerang
import Foundation
import RxSwift

protocol ShowsRepository {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[TrendingShow]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[ShowItem]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[PlayedShow]>
    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[AnticipatedShow]>

    func info(forShow show: Show) -> Observable<ShowInfo>
    func info(forPerson person: Person) -> Observable<PersonInfo>
    func detail(forShow show: Show) -> Observable<ShowDetailItem>
    func people(forShow show: Show) -> Observable<PeopleResult>
    func related(of show: Show) -> Observable<[ShowItem]>
    func fanart(for show: Show) -> Observable<FanartResponse>
}

struct ShowsRepositoryImplementation: ShowsRepository {
    let rest: RESTDataSource

    func info(forShow show: Show) -> Observable<ShowInfo> {
        return rest.get(ShowInfo.self, at: TMDBAPI.show(show))
    }

    func info(forPerson person: Person) -> Observable<PersonInfo> {
        return rest.get(PersonInfo.self, at: TMDBAPI.person(person))
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

    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[AnticipatedShow]> {
        return rest
            .get([AnticipatedShow].self, at:
                TraktvAPI.anticipated(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func people(forShow show: Show) -> Observable<PeopleResult> {
        return rest.get(PeopleResult.self, at: TraktvAPI.people(show))
    }

    func related(of show: Show) -> Observable<[ShowItem]> {
        return rest.get([ShowItem].self, at: TraktvAPI.relatedShows(show))
    }

    func fanart(for show: Show) -> Observable<FanartResponse> {
        return rest.get(FanartResponse.self, at: FanartAPI.show(show))
    }
}
