//
//  DataRequest.swift
//  Model
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Moya
extension Trakt {
    enum API {
        struct Page {
            var page: Int
            var limit: Int
        }

        case authorize
        case token(code: String)
        case logout(token: String)

        case trendingShows(Page)
        case popularShows(Page)
        case playedShows(Page)
        case watchedShows(Page)
        case collectedShows(Page)
        case anticipatedShows(Page)
        case showPeople(TraktItem)
        case seasons(TraktItem)
        case showSummary(TraktItem)
        case relatedShows(TraktItem)
        case peopleShows(Person)

        case trendingMovies(Page)
        case popularMovies(Page)
        case playedMovies(Page)
        case watchedMovies(Page)
        case collectedMovies(Page)
        case anticipatedMovies(Page)
        case moviePeople(TraktItem)
        case movieSummary(TraktItem)
        case relatedMovies(TraktItem)
        case peopleMovies(Person)

        case search(String, Page)

        case userSettings
        case userShowHistory(User)
        case userMovieHistory(User)
    }
}

extension Trakt.API: TargetType {
    var baseURL: URL {
        switch self {
        case .authorize: return Configuration.environment.traktWebURL
        default: return Configuration.environment.traktBaseURL
        }
    }

    var path: String {
        switch self {
        case .authorize: return "oauth/authorize"
        case .logout: return "oauth/revoke"
        case .token: return "oauth/token"
        case .trendingShows: return "shows/trending"
        case .popularShows: return "shows/popular"
        case .playedShows: return "shows/played"
        case .watchedShows: return "shows/watched"
        case .collectedShows: return "shows/collected"
        case .anticipatedShows: return "shows/anticipated"
        case .trendingMovies: return "movies/trending"
        case .popularMovies: return "movies/popular"
        case .playedMovies: return "movies/played"
        case .watchedMovies: return "movies/watched"
        case .collectedMovies: return "movies/collected"
        case .anticipatedMovies: return "movies/anticipated"

        case let .seasons(show): return "shows/\(show.ids.trakt)/seasons"

        case let .showSummary(show): return "shows/\(show.ids.trakt)"
        case let .movieSummary(movie): return "movies/\(movie.ids.trakt)"

        case let .showPeople(show): return "shows/\(show.ids.trakt)/people"
        case let .moviePeople(movie): return "movies/\(movie.ids.trakt)/people"

        case let .relatedShows(show): return "shows/\(show.ids.trakt)/related"
        case let .relatedMovies(movie): return "movies/\(movie.ids.trakt)/related"

        case let .peopleShows(person): return "people/\(person.ids.trakt)/shows"
        case let .peopleMovies(person): return "people/\(person.ids.trakt)/movies"

        case .search: return "search/movie,show,person"

        case .userSettings: return "users/settings"
        case let .userShowHistory(user): return "users/\(user.ids.slug)/history"
        case let .userMovieHistory(user): return "users/\(user.ids.slug)/history/movies"
        }
    }

    var method: Moya.Method {
        switch self {
        case .token, .logout: return .post
        default: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch method {
        case .post: return Task.requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default: return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        let auth: String?
        if let token = AccessToken.current?.accessToken {
            auth = "Bearer \(token)"
        } else {
            auth = nil
        }
        return [
            "Content-Type": "application/json",
            "trakt-api-version": "2",
            "trakt-api-key": Configuration.environment.traktClientID,
            "Authorization": auth ?? ""
        ]
    }

    private var pagination: [String: Any] {
        switch self {
        // case .played(_, let page), .trending(let page), .search(_, let page): return ["page": page.page, "limit": page.limit]
        case let .trendingShows(page),
             let .popularShows(page),
             let .playedShows(page),
             let .watchedShows(page),
             let .anticipatedShows(page),
             let .collectedShows(page),
             let .trendingMovies(page),
             let .popularMovies(page),
             let .playedMovies(page),
             let .watchedMovies(page),
             let .anticipatedMovies(page),
             let .collectedMovies(page),
             let .search(_, page): return ["page": page.page, "limit": page.limit]
        default: return [:]
        }
    }

    var parameters: [String: Any] {
        var parameters = pagination
        switch self {
        case let .token(code):
            return ["code": code,
                    "client_id": Configuration.environment.traktClientID,
                    "client_secret": Configuration.environment.traktClientSecret,
                    "grant_type": "authorization_code",
                    "redirect_uri": Configuration.environment.traktRedirectURI]
        case let .logout(token): return ["token": token,
                                         "client_id": Configuration.environment.traktClientID,
                                         "client_secret": Configuration.environment.traktClientSecret]
        case .authorize: return ["response_type": "code",
                                 "client_id": Configuration.environment.traktClientID,
                                 "redirect_uri": Configuration.environment.traktRedirectURI]
        case .showSummary, .movieSummary: return ["extended": "full"]
        case let .search(query, _): parameters["query"] = query
            return parameters
        //        case .myProfile: return ["extended":"full"]
        default: return parameters
        }
    }

    var cacheTime: TimeInterval {
        switch method {
        case .get: return 5.minutes
        default: return 0
        }
    }
}
