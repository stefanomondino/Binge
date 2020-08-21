import Boomerang
import Foundation
import RxSwift

protocol ConfigurationRepository {
    func tmdbConfiguration() -> Observable<TMDB.API.Configuration>
}

class ConfigurationAPIRepository: ConfigurationRepository {
    private lazy var tmbdConfigurationObservable = self.rest
        .get(TMDB.API.Configuration.self, at: TMDB.API.configuration)
        .do(onNext: { [weak self] in self?._configuration = $0 })
        .share(replay: 1, scope: .forever)
    private var _configuration: TMDB.API.Configuration?
    let rest: RESTDataSource

    init(rest: RESTDataSource) {
        self.rest = rest
    }

    func tmdbConfiguration() -> Observable<TMDB.API.Configuration> {
        if let configuration = _configuration {
            return .just(configuration)
        }
        return tmbdConfigurationObservable
    }
}
