//
//  SplashUseCaseSpec.swift
//  AppTests
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
@testable import Model
import Nimble
import Quick
import RxBlocking
import RxSwift

class SplashUseCaseSpec: QuickSpec {
    override func spec() {
        let container = ModelTestContainer()

        describe("The splash use case") {
            var useCase: SplashUseCase { container.useCases.splash }
            beforeEach {
//                container.mockJSONFile("test", at: .test)
            }
            context("when started") {
                it("should succeed") {
//                    expect(useCase.start()).first() == ()
                }
                it("should not error out") {
//                    expect(useCase.start()).notTo(throwError())
                }
            }
        }
    }
}
