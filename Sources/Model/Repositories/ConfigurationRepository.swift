import Boomerang
import Foundation
import RxSwift

protocol ConfigurationRepository {
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration>
}

class ConfigurationAPIRepository: ConfigurationRepository {
    private lazy var tmbdConfigurationObservable = self.rest
        .get(TMDBAPI.Configuration.self, at: TMDBAPI.configuration)
        .do(onNext: { [weak self] in self?._configuration = $0 })
        .share(replay: 1, scope: .forever)
    private var _configuration: TMDBAPI.Configuration?
    let rest: RESTDataSource

    init(rest: RESTDataSource) {
        self.rest = rest
    }

    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration> {
        if let configuration = _configuration {
            return .just(configuration)
        }
        return tmbdConfigurationObservable
    }
}
