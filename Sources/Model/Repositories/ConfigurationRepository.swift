import Boomerang
import Foundation
import RxSwift

protocol ConfigurationRepository {
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration>
}

class ConfigurationAPIRepository: ConfigurationRepository {
    private lazy var tmbdConfigurationObservable = self.rest
        .get(TMDBAPI.Configuration.self, at: TMDBAPI.configuration)
        .share(replay: 1, scope: .forever)

    let rest: RESTDataSource

    init(rest: RESTDataSource) {
        self.rest = rest
    }

    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration> {
        return tmbdConfigurationObservable
    }
}
