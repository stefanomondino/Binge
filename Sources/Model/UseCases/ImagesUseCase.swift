import Foundation
import RxSwift

public protocol ImagesUseCase {
    func poster(for show: ShowItem) -> Observable<WithImage>
    func poster(for movie: MovieItem) -> Observable<WithImage>
    func image(forPerson person: Person) -> Observable<WithImage>
    func image(forSeason season: Season.Info) -> Observable<WithImage>
    func image(for episode: Season.Episode) -> Observable<WithImage>
    func image(for object: DownloadableImage) -> Observable<WithImage>
}
