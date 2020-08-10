//
//  MockedContainer.swift
//  Model
//
//  Created by Stefano Mondino on 28/07/2020.
//

import Foundation
@testable import Model

/// A test container wrapping the default one. Main focus: use mocked datasources and test how UseCases respond.
class TestContainer: ModelContainer {
    var handlers: Handlers { container.handlers }
    var useCases: UseCaseContainer { container.useCases }

    private struct Environment: Model.Environment {
        let baseURL: URL = URL(string: "https://google.com")!
        let debugEnabled: Bool = true
    }

    let container: ModelDependencyContainer = DefaultModelDependencyContainer(environment: Environment())
    let dataSource: MockDataSource = MockDataSource()

    init() {
        container.dataSources.register(for: .rest, scope: .eagerSingleton, handler: { self.dataSource })
    }

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: APIProvider) {
        dataSource.mockJSONFile(name, bundle: Bundle(for: TestContainer.self), statusCode: statusCode, for: target)
    }
}
