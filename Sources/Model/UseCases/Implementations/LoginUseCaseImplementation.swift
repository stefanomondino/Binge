import RxSwift

struct LoginUseCaseImplementation: LoginUseCase {
    let authorization: AuthorizationRepository

    public func webViewURL() -> URL? {
        return authorization.webViewURL()
    }

    public func login() -> Observable<Void> {
        return authorization.token()
    }
}
