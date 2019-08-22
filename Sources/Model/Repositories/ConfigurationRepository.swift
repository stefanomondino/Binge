import Foundation
import Boomerang
import RxSwift
import Moya

 protocol ConfigurationRepository {
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration>
}

 class ConfigurationAPIRepository: ConfigurationRepository {
    private lazy var tmbdConfigurationObservable: Observable<TMDBAPI.Configuration> = DataSources.tmdb.object(for: .configuration).share(replay: 1, scope: .forever)
    
    func tmdbConfiguration() -> Observable<TMDBAPI.Configuration> {
        return tmbdConfigurationObservable
    }
}

