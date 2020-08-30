import RxSwift

public protocol ProfileUseCase {
    func webViewURL() -> URL?
    func login() -> Observable<Void>
    func logout() -> Observable<Void>
    func isLogged() -> Observable<Bool>
    func user() -> Observable<User.Settings>
}
