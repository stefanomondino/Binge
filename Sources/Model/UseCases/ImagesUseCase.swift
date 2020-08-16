import Foundation
import RxSwift

public protocol ImagesUseCase {
    func poster(forShow show: Show) -> Observable<WithImage>
    func image(forPerson person: Person) -> Observable<WithImage>
    func image(forSeason season: SeasonInfo) -> Observable<WithImage>
}
