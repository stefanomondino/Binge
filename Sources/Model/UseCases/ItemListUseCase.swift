import Foundation
import RxSwift

public enum PageInfo {
    case popular
    case trending
    case watched
    case collected
    case anticipated
}

public protocol ItemListUseCase {
    var page: PageInfo { get }
    func items(currentPage: Int, pageSize: Int) -> Observable<[ItemContainer]>
}
