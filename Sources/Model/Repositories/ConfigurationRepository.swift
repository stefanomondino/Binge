import Foundation
import Boomerang
import RxSwift
import Moya

 protocol ConfigurationRepository {
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration>
}

class ConfigurationAPIRepository: ConfigurationRepository {
    private lazy var tmbdConfigurationObservable: Observable<TMDBAPI.Configuration> = self.tmdb.object(for: .configuration).share(replay: 1, scope: .forever)
    
    let tmdb: TMDBDataSource
    
    init(tmdb: TMDBDataSource) {
        self.tmdb = tmdb
    }
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration> {
        return tmbdConfigurationObservable
    }
}

