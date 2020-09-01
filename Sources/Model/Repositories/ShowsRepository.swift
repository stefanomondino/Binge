import Boomerang
import Foundation
import RxSwift

protocol ShowsRepository {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Trending]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Item]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Played]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Played]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Played]>
    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Anticipated]>

    func info(forShow show: TraktItem) -> Observable<TMDB.Show.Info>
    func info(forPerson person: Trakt.Person) -> Observable<TMDB.Person.Info>
    func detail(forShow show: TraktItem) -> Observable<Trakt.Show.Detail>
    func people(forShow show: TraktItem) -> Observable<Trakt.PeopleResult>
    func personCast(for person: Trakt.Person) -> Observable<Trakt.Show.Cast.Response>
    func related(of show: TraktItem) -> Observable<[Trakt.Show.Item]>
    func fanart(for show: TraktItem) -> Observable<FanartResponse>
    func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> Observable<TMDB.Season.Info>
    func info(for episode: Trakt.Episode, of show: TraktShowItem) -> Observable<TMDB.Season.Episode>
}

struct ShowsRepositoryImplementation: ShowsRepository {
    let rest: RESTDataSource

    func info(forShow show: TraktItem) -> Observable<TMDB.Show.Info> {
        return rest.get(TMDB.Show.Info.self, at: TMDB.API.show(show))
    }

    func info(for episode: Trakt.Episode, of show: TraktShowItem) -> Observable<TMDB.Season.Episode> {
        return rest.get(TMDB.Season.Episode.self, at: TMDB.API.episode(episode, show))
    }

    func info(forPerson person: Trakt.Person) -> Observable<TMDB.Person.Info> {
        return rest.get(TMDB.Person.Info.self, at: TMDB.API.person(person))
    }

    func detail(forShow show: TraktItem) -> Observable<Trakt.Show.Detail> {
        return rest.get(Trakt.Show.Detail.self, at: Trakt.API.showSummary(show))
//        return rest.get(Show.DetailItem.self, at: TMDB.API.show(show))
    }

    func trending(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Trending]> {
        return rest
            .get([Trakt.Show.Trending].self,
                 at: Trakt.API.trendingShows(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func played(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Played]> {
        return rest
            .get([Trakt.Show.Played].self, at: Trakt.API.playedShows(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func popular(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Item]> {
        return rest
            .get([Trakt.Show.Item].self, at: Trakt.API.popularShows(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func watched(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Played]> {
        return rest
            .get([Trakt.Show.Played].self, at: Trakt.API.watchedShows(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func collected(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Played]> {
        return rest
            .get([Trakt.Show.Played].self, at:
                Trakt.API.collectedShows(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Show.Anticipated]> {
        return rest
            .get([Trakt.Show.Anticipated].self, at:
                Trakt.API.anticipatedShows(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func people(forShow show: TraktItem) -> Observable<Trakt.PeopleResult> {
        return rest.get(Trakt.PeopleResult.self, at: Trakt.API.showPeople(show))
    }

    func personCast(for person: Trakt.Person) -> Observable<Trakt.Show.Cast.Response> {
        return rest.get(Trakt.Show.Cast.Response.self, at: Trakt.API.peopleShows(person))
    }

    func related(of show: TraktItem) -> Observable<[Trakt.Show.Item]> {
        return rest.get([Trakt.Show.Item].self, at: Trakt.API.relatedShows(show))
    }

    func fanart(for show: TraktItem) -> Observable<FanartResponse> {
        return rest.get(FanartResponse.self, at: FanartAPI.show(show))
    }

    public func seasonDetail(for season: TMDB.Season.Info, of show: TraktShowItem) -> Observable<TMDB.Season.Info> {
        return rest.get(TMDB.Season.Info.self, at: TMDB.API.seasonDetail(season, show))
    }
}
