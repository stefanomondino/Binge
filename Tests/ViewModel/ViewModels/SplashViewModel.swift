//
//  SplashViewModel.swift
//  ViewModelTests
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Quick
import Nimble
import RxBlocking
import RxSwift
import Boomerang
import Model
@testable import ViewModel

class SplashViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("The splash viewModel") {
            
            var useCase = MockSplashUseCase()
            
            context("when started") {
                var viewModel = SplashViewModel()
                beforeEach {
                    UseCases.splash = useCase.configure(with: .just(()), for: \.startObservable)
                    viewModel = SplashViewModel()
                    delayed { viewModel.start() }
                }
                it("should emit a route") {
                    expect(viewModel.nextRoute).first().to(beAKindOf(Route.self))
                }
                
            }
            context("when an error occurs") {
                var viewModel = SplashViewModel()
                beforeEach {
                    UseCases.splash = useCase.configure(with: .error(NSError(domain: "", code: 200, userInfo: nil)), for: \.startObservable)
                    viewModel = SplashViewModel()
                    delayed { viewModel.start() }
                }
                it("should emit a route") {
                    expect { try viewModel.selection.errors.toBlocking().first() }.notTo(beNil())
                }

            }
        }
    }
}

