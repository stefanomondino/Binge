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

    func image<T>(from info: T?, with keyPath: KeyPath<T, String?>, sizes: KeyPath<TMDB.Image, [String]>) -> Observable<WithImage> {
        return configuration.tmdbConfiguration().map { configuration -> WithImage in

            let url = configuration.images.secureBaseUrl
            let sizes = configuration.images[keyPath: sizes]
            let prefix = sizes.first(where: { $0 == "w500" }) ?? sizes.last ?? ""
            guard let path = info?[keyPath: keyPath] else {
                return ""
            }
            return url
                .appendingPathComponent(prefix)
                .appendingPathComponent(path)
        }
    }

    func poster(for show: TraktShowItem) -> Observable<WithImage> {
        return shows.info(forShow: show.item)
            .map { $0 }
            .catchErrorJustReturn(nil)
            .flatMapLatest {
                self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
            }
        //        return
    }

    func poster(for movie: TraktMovieItem) -> Observable<WithImage> {
        return movies.info(forMovie: movie.item)
            .map { $0 }
            .catchErrorJustReturn(nil)
            .flatMapLatest {
                self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
            }
    }

    func image(forPerson person: Trakt.Person) -> Observable<WithImage> {
        return shows.info(forPerson: person)
            .map { $0 }
            .catchErrorJustReturn(nil)
            .flatMapLatest {
                self.image(from: $0, with: \.profilePath, sizes: \.profileSizes)
            }
    }

    func image(for image: DownloadableImage) -> Observable<WithImage> {
        return Observable.just(image).flatMapLatest {
            self.image(from: $0, with: \.defaultImage, sizes: image.allowedSizes)
        }
    }

    func image(forSeason season: TMDB.Season.Info) -> Observable<WithImage> {
        return Observable.just(season).flatMapLatest {
            self.image(from: $0, with: \.posterPath, sizes: \.posterSizes)
        }
    }

    func image(for episode: TMDB.Season.Episode) -> Observable<WithImage> {
        return Observable.just(episode).flatMapLatest {
            self.image(from: $0, with: \.stillPath, sizes: \.stillSizes)
        }
    }
}
