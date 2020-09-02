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

class TrendingShowsUseCaseSpec: QuickSpec {
    override func spec() {
        let container = TestContainer()

        describe("The splash use case") {
            var useCase: ItemListUseCase { container.useCases.shows.trending }

            context("when downloading a list of items") {
                beforeEach {
                    container.mockJSONFile("Trending.Shows.Mock", at: .trendingShows(.init(page: 0, limit: 20)))
                }
                it("should succeed and properly map") {
                    expect {
                        let items = try useCase.items(currentPage: 0, pageSize: 20).toBlocking().first()
                        expect(items).notTo(beNil())
                        expect(items?.first).to(beAnInstanceOf(Trakt.Show.Trending.self))
                        expect((items?.first as? Trakt.Show.Trending)?.title) == "Breaking Bad"
                        expect((items?.last as? Trakt.Show.Trending)?.title) == "The Walking Dead"
                        return items
                    }.notTo(throwError())
                }
            }
            context("when the remote list is corrupted") {
                beforeEach {
                    container.mockJSONFile("Trending.Shows.Mock",
                                           statusCode: 400,
                                           at: .trendingShows(.init(page: 0, limit: 20)))
                }
                it("should succeed and properly map") {
                    expect {
                        try useCase.items(currentPage: 0, pageSize: 20).toBlocking().first()
                    }.to(throwError())
                }
            }
        }
    }
}
