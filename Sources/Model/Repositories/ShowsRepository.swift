import Boomerang
import Foundation
import RxSwift

protocol ShowsRepository {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[Show.Trending]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[Show.ShowItemImplementation]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[Show.Played]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[Show.Played]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[Show.Played]>
    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Show.Anticipated]>

    func info(forShow show: Item) -> Observable<Show.Info>
    func info(forPerson person: Person) -> Observable<PersonInfo>
    func detail(forShow show: Item) -> Observable<Show.DetailItem>
    func people(forShow show: Item) -> Observable<PeopleResult>
    func personCast(for person: Person) -> Observable<Show.Cast.Response>
    func related(of show: Item) -> Observable<[Show.ShowItemImplementation]>
    func fanart(for show: Item) -> Observable<FanartResponse>
    func seasonDetail(for season: Season.Info, of show: ShowItem) -> Observable<Season.Info>
}

struct ShowsRepositoryImplementation: ShowsRepository {
    let rest: RESTDataSource

    func info(forShow show: Item) -> Observable<Show.Info> {
        return rest.get(Show.Info.self, at: TMDB.API.show(show))
    }

    func info(forPerson person: Person) -> Observable<PersonInfo> {
        return rest.get(PersonInfo.self, at: TMDB.API.person(person))
    }

    func detail(forShow show: Item) -> Observable<Show.DetailItem> {
        return rest.get(Show.DetailItem.self, at: TraktvAPI.showSummary(show))
//        return rest.get(Show.DetailItem.self, at: TMDB.API.show(show))
    }

    func trending(currentPage: Int, pageSize: Int) -> Observable<[Show.Trending]> {
        return rest
            .get([Show.Trending].self,
                 at: TraktvAPI.trendingShows(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func played(currentPage: Int, pageSize: Int) -> Observable<[Show.Played]> {
        return rest
            .get([Show.Played].self, at: TraktvAPI.playedShows(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func popular(currentPage: Int, pageSize: Int) -> Observable<[Show.ShowItemImplementation]> {
        return rest
            .get([Show.ShowItemImplementation].self, at: TraktvAPI.popularShows(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func watched(currentPage: Int, pageSize: Int) -> Observable<[Show.Played]> {
        return rest
            .get([Show.Played].self, at: TraktvAPI.watchedShows(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func collected(currentPage: Int, pageSize: Int) -> Observable<[Show.Played]> {
        return rest
            .get([Show.Played].self, at:
                TraktvAPI.collectedShows(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Show.Anticipated]> {
        return rest
            .get([Show.Anticipated].self, at:
                TraktvAPI.anticipatedShows(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func people(forShow show: Item) -> Observable<PeopleResult> {
        return rest.get(PeopleResult.self, at: TraktvAPI.showPeople(show))
    }

    func personCast(for person: Person) -> Observable<Show.Cast.Response> {
        return rest.get(Show.Cast.Response.self, at: TraktvAPI.peopleShows(person))
    }

    func related(of show: Item) -> Observable<[Show.ShowItemImplementation]> {
        return rest.get([Show.ShowItemImplementation].self, at: TraktvAPI.relatedShows(show))
    }

    func fanart(for show: Item) -> Observable<FanartResponse> {
        return rest.get(FanartResponse.self, at: FanartAPI.show(show))
    }

    public func seasonDetail(for season: Season.Info, of show: ShowItem) -> Observable<Season.Info> {
        return rest.get(Season.Info.self, at: TMDB.API.seasonDetail(season, show.item))
    }
}
