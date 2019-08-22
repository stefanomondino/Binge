import Foundation
import Boomerang
import RxSwift
import Moya

 public protocol ImagesUseCaseType {
    func poster(forShow show: Show) -> Observable<WithImage>
}

 struct ImagesUseCase: ImagesUseCaseType {
    
    func image(from info: ShowInfo, with keyPath: KeyPath<ShowInfo, String?>) -> Observable<WithImage> {
        
        return Repositories.configuration.tmdbConfiguration().map { configuration in
        
        let url  = configuration.images.secureBaseUrl
        let posterSizes = configuration.images.posterSizes
        let prefix = posterSizes.first(where: { $0 == "w500"}) ?? posterSizes.last ?? ""
        guard let path = info[keyPath: keyPath] else {
            return ""
        }
        return url
            .appendingPathComponent(prefix)
            .appendingPathComponent(path)
        }
    }

     
    func poster(forShow show: Show) -> Observable<WithImage> {
        return Repositories.shows.info(forShow: show).flatMapLatest {
            self.image(from: $0, with: \.posterPath)
        }
//        return
    }
}

