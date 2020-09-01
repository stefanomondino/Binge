import Foundation
import RxSwift

public protocol ImagesUseCase {
    func poster(for item: TraktItemContainer) -> Observable<WithImage>
    func image(for person: Trakt.Person) -> Observable<WithImage>
    func image(for season: TMDB.Season.Info) -> Observable<WithImage>
    func image(for episode: TMDB.Season.Episode) -> Observable<WithImage>
    func image(for object: DownloadableImage) -> Observable<WithImage>
}
