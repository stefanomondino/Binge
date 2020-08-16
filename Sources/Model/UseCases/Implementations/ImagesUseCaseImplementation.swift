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
    let movies: MoviesRepository

    init(configuration: ConfigurationRepository,
         shows: ShowsRepository,
         movies: MoviesRepository) {
        self.configuration = configuration
        self.shows = shows
        self.movies = movies
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

    func poster(for show: ShowItem) -> Observable<WithImage> {
        return shows.info(forShow: show.item).flatMapLatest {
            self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
        }
        //        return
    }

    func poster(for movie: MovieItem) -> Observable<WithImage> {
        return movies.info(forMovie: movie.item)
            .debug("HELP", trimOutput: false)
            .flatMapLatest {
                self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
            }
        //        return
    }

    func image(forPerson person: Person) -> Observable<WithImage> {
        return shows.info(forPerson: person).flatMapLatest {
            self.image(from: $0, with: \.profilePath, sizes: \.profileSizes)
        }
    }

    func image(forSeason season: Season.Info) -> Observable<WithImage> {
        return Observable.just(season).flatMapLatest {
            self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
        }
    }
}
