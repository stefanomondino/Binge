import RxSwift

struct LoginUseCaseImplementation: LoginUseCase {
    let authorization: AuthorizationRepository

    func login(username: String, password: String) -> Observable<Void> {
        return authorization
            .login(username: username, password: password)
            .map { _ in }
    }
}
