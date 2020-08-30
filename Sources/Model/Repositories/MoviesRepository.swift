import Boomerang
import Foundation
import RxSwift

protocol MoviesRepository {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Trending]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Item]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Played]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Played]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Played]>
    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Anticipated]>

    func info(forMovie show: TraktItem) -> Observable<TMDB.Movie.Info>
    func info(forPerson person: Trakt.Person) -> Observable<TMDB.Person.Info>
    func detail(forMovie show: TraktItem) -> Observable<Trakt.Movie.Detail>
    func people(forMovie show: TraktItem) -> Observable<Trakt.PeopleResult>
    func related(of movie: TraktItem) -> Observable<[Trakt.Movie.Item]>
    func fanart(for movie: TraktItem) -> Observable<FanartResponse>
    func personCast(for person: Trakt.Person) -> Observable<Trakt.Movie.Cast.Response>
}

struct MoviesRepositoryImplementation: MoviesRepository {
    let rest: RESTDataSource

    func info(forMovie movie: TraktItem) -> Observable<TMDB.Movie.Info> {
        return rest.get(TMDB.Movie.Info.self, at: TMDB.API.movie(movie))
    }

    func info(forPerson person: Trakt.Person) -> Observable<TMDB.Person.Info> {
        return rest.get(TMDB.Person.Info.self, at: TMDB.API.person(person))
    }

    func detail(forMovie show: TraktItem) -> Observable<Trakt.Movie.Detail> {
        return rest.get(Trakt.Movie.Detail.self, at: Trakt.API.movieSummary(show))
    }

    func trending(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Trending]> {
        return rest
            .get([Trakt.Movie.Trending].self,
                 at: Trakt.API.trendingMovies(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func played(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Played]> {
        return rest
            .get([Trakt.Movie.Played].self, at: Trakt.API.playedMovies(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func popular(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Item]> {
        return rest
            .get([Trakt.Movie.Item].self, at: Trakt.API.popularMovies(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func watched(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Played]> {
        return rest
            .get([Trakt.Movie.Played].self, at: Trakt.API.watchedMovies(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func collected(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Played]> {
        return rest
            .get([Trakt.Movie.Played].self, at:
                Trakt.API.collectedMovies(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Trakt.Movie.Anticipated]> {
        return rest
            .get([Trakt.Movie.Anticipated].self, at:
                Trakt.API.anticipatedMovies(Trakt.API.Page(page: currentPage, limit: pageSize)))
    }

    func people(forMovie movie: TraktItem) -> Observable<Trakt.PeopleResult> {
        return rest.get(Trakt.PeopleResult.self, at: Trakt.API.moviePeople(movie))
    }

    func related(of show: TraktItem) -> Observable<[Trakt.Movie.Item]> {
        return rest.get([Trakt.Movie.Item].self, at: Trakt.API.relatedMovies(show))
    }

    func personCast(for person: Trakt.Person) -> Observable<Trakt.Movie.Cast.Response> {
        return rest.get(Trakt.Movie.Cast.Response.self, at: Trakt.API.peopleMovies(person))
    }

    func fanart(for movie: TraktItem) -> Observable<FanartResponse> {
        return rest.get(FanartResponse.self, at: FanartAPI.movie(movie))
    }
}
