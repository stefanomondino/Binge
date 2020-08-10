import RxSwift

public protocol LoginUseCase {
    func login(username: String, password: String) -> Observable<Void>
}
