//
//  Tests.swift
//  Binge
//
//  Created by Stefano Mondino on 07/09/2020.
//

@testable import Binge_iOS
import Boomerang
import Foundation
@testable import Model

class TestContainer: RootContainer {
    var environment: Binge_iOS.Environment { defaultContainer.environment }

    var viewModels: ViewModelContainer { defaultContainer.viewModels }

    var views: ViewContainer { defaultContainer.views }

    var routeFactory: RouteFactory { defaultContainer.routeFactory }

    var styleFactory: StyleFactory { defaultContainer.styleFactory }

    var translations: StringsFactory { defaultContainer.translations }

    var model: ModelContainer { modelContainer }

    let modelContainer = ModelTestContainer()
    let defaultContainer = InitializationRoot()
    init() {}

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: Trakt.API) {
        modelContainer.mockJSONFile(name, statusCode: statusCode, at: target)
    }

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: TMDB.API) {
        modelContainer.mockJSONFile(name, statusCode: statusCode, at: target)
    }

    func mockJSONFile(_ name: String, statusCode: Int = 200, at target: FanartAPI) {
        modelContainer.mockJSONFile(name, statusCode: statusCode, at: target)
    }
}
