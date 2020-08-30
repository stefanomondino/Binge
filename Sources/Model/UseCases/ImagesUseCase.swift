import Foundation
import RxSwift

public protocol ImagesUseCase {
    func poster(for show: TraktShowItem) -> Observable<WithImage>
    func poster(for movie: TraktMovieItem) -> Observable<WithImage>
    func image(forPerson person: Trakt.Person) -> Observable<WithImage>
    func image(forSeason season: TMDB.Season.Info) -> Observable<WithImage>
    func image(for episode: TMDB.Season.Episode) -> Observable<WithImage>
    func image(for object: DownloadableImage) -> Observable<WithImage>
}
