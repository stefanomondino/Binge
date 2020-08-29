import RxSwift

struct ProfileUseCaseImplementation: ProfileUseCase {
    let authorization: AuthorizationRepository
    let profile: ProfileRepository
    public func webViewURL() -> URL? {
        return authorization.webViewURL()
    }

    public func login() -> Observable<Void> {
        return authorization.token()
    }

    func logout() -> Observable<Void> {
        return .just(())
    }

    func isLogged() -> Observable<Bool> {
        authorization.isLogged()
    }

    func user() -> Observable<User> {
        profile.userSettings().map { $0.user }
    }
}
