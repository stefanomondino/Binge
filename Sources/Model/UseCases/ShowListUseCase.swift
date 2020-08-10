import Foundation
import RxSwift

public enum PageInfo {
    case popular
    case trending
    case watched
}

public protocol ShowListUseCase {
    var page: PageInfo { get }
    func shows(currentPage: Int, pageSize: Int) -> Observable<[WithShow]>
}
