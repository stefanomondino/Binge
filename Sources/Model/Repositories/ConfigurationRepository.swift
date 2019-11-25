import Foundation
import Boomerang
import RxSwift
import Moya

 protocol ConfigurationRepository {
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration>
}

class ConfigurationAPIRepository: ConfigurationRepository {
    private lazy var tmbdConfigurationObservable: Observable<TMDBAPI.Configuration> = self.rest.get(TMDBAPI.Configuration.self, at: TMDBAPI.configuration)
        .share(replay: 1, scope: .forever)
    
    let rest: RESTDataSource
    
    init(rest: RESTDataSource) {
        self.rest = rest
    }
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration> {
        return tmbdConfigurationObservable
    }
}

