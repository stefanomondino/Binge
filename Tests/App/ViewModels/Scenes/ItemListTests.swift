//
//  ScenesTests.swift
//  AppTests
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

@testable import Binge_iOS
import Boomerang
@testable import Model
import Nimble
import Quick
import RxBlocking
import RxSwift

extension Int: TraktItem {
    public var ids: Trakt.Ids {
        .init(trakt: self, slug: "\(self)")
    }

    public var item: TraktItem {
        self
    }
}

class ItemListTests: QuickSpec {
    var disposable: Disposable?
    override func spec() {
        let container = TestContainer()

        describe("A trending shows item list") {
            var viewModel = ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                                              useCase: container.model.useCases.shows.trending,
                                              routeFactory: container.routeFactory)
            beforeEach {
                viewModel = ItemListViewModel(itemViewModelFactory: container.viewModels.items,
                                              useCase: container.model.useCases.shows.trending,
                                              routeFactory: container.routeFactory)
            }

            context("when reloaded") {
                let first = IndexPath(item: 0, section: 0)
                let second = IndexPath(item: 1, section: 0)
                container.mockJSONFile("Trending.Shows.Mock", at: .trendingShows(.init(page: 0, limit: 20)))
                container.mockJSONFile("Trending.Shows.Mock", at: .trendingShows(.init(page: 1, limit: 20)))
                container.mockJSONFile("TMDB.Show.List", at: TMDB.API.show(1))

                it("should load a single loader item and then a list of objects. Each object must trigger navigation") {
                    expect(viewModel.sectionsRelay)
                        .triggering { viewModel.reload() }
                        .to(haveCount(1))

                    expect(viewModel[first]).as(LoadMoreItemViewModel.self) { loader in
                        self.executeAndSync {
                            _ = loader.reload()
                        }
                        expect(viewModel.sections.first?.items.count) == 3
                        expect(viewModel[first])
                            .as(GenericItemViewModel.self) { viewModel in
                                expect(viewModel.title) == "Breaking Bad"
                                expect(viewModel.subtitle) == "2008"
                                expect(viewModel.showIdentifier) == .posterOnly
                            }.notTo(throwError())
                        expect(viewModel[second])
                            .as(GenericItemViewModel.self) { viewModel in
                                expect(viewModel.title) == "The Walking Dead"
                                expect(viewModel.subtitle) == "2010"
                                expect(viewModel.showIdentifier) == .posterOnly
                            }.notTo(throwError())

                        expect(viewModel[first])
                            .as(ShowDetailViewModel.self)
                            .to(throwError())

                        viewModel.selectItem(at: first)
                        expect(viewModel.routes)
                            .triggering { viewModel.selectItem(at: first) }
                            .as(NavigationRoute.self)
                            .notTo(throwError())

                    }.notTo(throwError())
                }
            }
        }
    }
}
