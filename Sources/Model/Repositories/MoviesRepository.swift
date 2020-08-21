import Boomerang
import Foundation
import RxSwift

protocol MoviesRepository {
    func trending(currentPage: Int, pageSize: Int) -> Observable<[Movie.Trending]>
    func popular(currentPage: Int, pageSize: Int) -> Observable<[Movie.MovieItemImplementation]>
    func played(currentPage: Int, pageSize: Int) -> Observable<[Movie.Played]>
    func watched(currentPage: Int, pageSize: Int) -> Observable<[Movie.Played]>
    func collected(currentPage: Int, pageSize: Int) -> Observable<[Movie.Played]>
    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Movie.Anticipated]>

    func info(forMovie show: Item) -> Observable<Movie.Info>
    func info(forPerson person: Person) -> Observable<PersonInfo>
    func detail(forMovie show: Item) -> Observable<Movie.DetailItem>
    func people(forMovie show: Item) -> Observable<PeopleResult>
    func related(of movie: Item) -> Observable<[Movie.MovieItemImplementation]>
    func fanart(for movie: Item) -> Observable<FanartResponse>
    func personCast(for person: Person) -> Observable<Movie.Cast.Response>
}

struct MoviesRepositoryImplementation: MoviesRepository {
    let rest: RESTDataSource

    func info(forMovie movie: Item) -> Observable<Movie.Info> {
        return rest.get(Movie.Info.self, at: TMDB.API.movie(movie))
    }

    func info(forPerson person: Person) -> Observable<PersonInfo> {
        return rest.get(PersonInfo.self, at: TMDB.API.person(person))
    }

    func detail(forMovie show: Item) -> Observable<Movie.DetailItem> {
        return rest.get(Movie.DetailItem.self, at: TraktvAPI.movieSummary(show))
    }

    func trending(currentPage: Int, pageSize: Int) -> Observable<[Movie.Trending]> {
        return rest
            .get([Movie.Trending].self,
                 at: TraktvAPI.trendingMovies(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func played(currentPage: Int, pageSize: Int) -> Observable<[Movie.Played]> {
        return rest
            .get([Movie.Played].self, at: TraktvAPI.playedMovies(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func popular(currentPage: Int, pageSize: Int) -> Observable<[Movie.MovieItemImplementation]> {
        return rest
            .get([Movie.MovieItemImplementation].self, at: TraktvAPI.popularMovies(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func watched(currentPage: Int, pageSize: Int) -> Observable<[Movie.Played]> {
        return rest
            .get([Movie.Played].self, at: TraktvAPI.watchedMovies(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func collected(currentPage: Int, pageSize: Int) -> Observable<[Movie.Played]> {
        return rest
            .get([Movie.Played].self, at:
                TraktvAPI.collectedMovies(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func anticipated(currentPage: Int, pageSize: Int) -> Observable<[Movie.Anticipated]> {
        return rest
            .get([Movie.Anticipated].self, at:
                TraktvAPI.anticipatedMovies(TraktvAPI.Page(page: currentPage, limit: pageSize)))
    }

    func people(forMovie movie: Item) -> Observable<PeopleResult> {
        return rest.get(PeopleResult.self, at: TraktvAPI.moviePeople(movie))
    }

    func related(of show: Item) -> Observable<[Movie.MovieItemImplementation]> {
        return rest.get([Movie.MovieItemImplementation].self, at: TraktvAPI.relatedMovies(show))
    }

    func personCast(for person: Person) -> Observable<Movie.Cast.Response> {
        return rest.get(Movie.Cast.Response.self, at: TraktvAPI.peopleMovies(person))
    }

    func fanart(for movie: Item) -> Observable<FanartResponse> {
        return rest.get(FanartResponse.self, at: FanartAPI.movie(movie))
    }
}
