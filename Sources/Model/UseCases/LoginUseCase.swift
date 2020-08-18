import RxSwift

public protocol LoginUseCase {
    func webViewURL() -> URL?
    func login() -> Observable<Void>
}
