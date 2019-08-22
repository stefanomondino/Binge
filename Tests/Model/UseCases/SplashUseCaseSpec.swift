//
//  SplashUseCaseSpec.swift
//  AppTests
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift
import Boomerang
import Moya
@testable import Model

class SplashUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("The splash use case") {
            
            let repository: MainRepository = {
                var repo = Repositories.main as! MainRepository
                repo.dataSource = MockDataSource<API>()
                return repo
            }()
            
            context("when started") {
                var observable: Observable<()>!
                beforeEach {
                        APIContainer.register(API.test) { "TEST".jsonResponse() }
                        observable = repository.setup()//.share(replay: 1, scope: .forever)
                    }
                it("should download a configuration file") {
                    expect(observable).first().notTo(beNil())
                }
                afterEach {
                    //Cleanup
                }
            }
            context("when an error occurs") {
                var observable: Observable<()>!
                beforeEach {
//                    APIContainer.register(InformationsAPI.configuration) { "TMDB_Configuration".jsonResponse(code: 400) }
//                    observable = repository.configuration()//.share(replay: 1, scope: .forever)
                }
                it("should emit an error") {
//                    expect { try observable.toBlocking().toArray() }.to(throwError())
                }
            }
        }
    }
}
