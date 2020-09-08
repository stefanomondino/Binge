//
//  MockedContainer.swift
//  Model
//
//  Created by Stefano Mondino on 28/07/2020.
//

import Foundation
@testable import Model

/// A test container wrapping the default one. Main focus: use mocked datasources and test how UseCases respond.
class ModelTestContainer: ModelContainer {
    var handlers: Handlers { container.handlers }
    var useCases: UseCaseContainer { container.useCases }

    private struct Environment: Model.Environment {
        var traktBaseURL = URL(string: "https://google.com")!

        var traktWebURL = URL(string: "https://google.com")!

        var traktRedirectURI: String = ""

        var traktClientID: String = ""

        var traktClientSecret: String = ""

        var fanartAPIKey: String = ""

        var fanartBaseURL = URL(string: "https://google.com")!

        var tmdbBaseURL = URL(string: "https://google.com")!

        var tmdbAPIKey: String = ""
    }

    let container: ModelDependencyContainer = DefaultModelDependencyContainer(environment: Environment())
    let dataSource = MockDataSource()

    init() {
        container.dataSources.register(for: .rest, scope: .eagerSingleton, handler: { self.dataSource })
    }

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: Trakt.API) {
        dataSource.mockJSONFile(name, bundle: Bundle(for: ModelTestContainer.self), statusCode: statusCode, for: target)
    }

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: TMDB.API) {
        dataSource.mockJSONFile(name, bundle: Bundle(for: ModelTestContainer.self), statusCode: statusCode, for: target)
    }

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: FanartAPI) {
        dataSource.mockJSONFile(name, bundle: Bundle(for: ModelTestContainer.self), statusCode: statusCode, for: target)
    }
}
