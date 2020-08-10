import Boomerang
@testable import Model
import Nimble
import Quick
import RxBlocking
import RxSwift

class LoginUseCaseSpec: QuickSpec {
    override func spec() {
        let container = TestContainer()

        describe("The Login use case") {
            var useCase: LoginUseCase { container.useCases.login }

            context("when successful") {
                beforeEach {
                    container.mockJSONFile("LoginSuccess", at: .login(username: "", password: ""))
                }
                it("should succeed") {
                    expect(useCase.login(username: "", password: "")).first() == ()
                }
                it("should not error out") {
                    expect(useCase.login(username: "", password: "")).notTo(throwError())
                }
            }
            context("when invalid credentials") {
                beforeEach {
                    container.mockJSONFile("LoginFailed", statusCode: 401, at: .login(username: "", password: ""))
                }

                it("should fail") {
                    expect(useCase.login(username: "", password: "").errors).first().notTo(beNil())
                }
            }
        }
    }
}
