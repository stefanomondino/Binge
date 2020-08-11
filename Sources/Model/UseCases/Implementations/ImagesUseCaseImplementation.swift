//
//  ImagesUseCaseImplementation.swift
//  Model
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation
import RxSwift

class ImagesUseCaseImplementation: ImagesUseCase {
    let configuration: ConfigurationRepository
    let shows: ShowsRepository

    init(configuration: ConfigurationRepository, shows: ShowsRepository) {
        self.configuration = configuration
        self.shows = shows
    }

    func image<T: Codable>(from info: T, with keyPath: KeyPath<T, String?>, sizes: KeyPath<TMDBAPI.Image, [String]>) -> Observable<WithImage> {
        return configuration.tmdbConfiguration().map { configuration in

            let url = configuration.images.secureBaseUrl
            let sizes = configuration.images[keyPath: sizes]
            let prefix = sizes.first(where: { $0 == "w500" }) ?? sizes.last ?? ""
            guard let path = info[keyPath: keyPath] else {
                return ""
            }
            return url
                .appendingPathComponent(prefix)
                .appendingPathComponent(path)
        }
    }

    func poster(forShow show: Show) -> Observable<WithImage> {
        return shows.info(forShow: show).flatMapLatest {
            self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
        }
        //        return
    }

    func image(forPerson person: Person) -> Observable<WithImage> {
        return shows.info(forPerson: person).flatMapLatest {
            self.image(from: $0, with: \.profilePath, sizes: \.profileSizes)
        }
    }
}
