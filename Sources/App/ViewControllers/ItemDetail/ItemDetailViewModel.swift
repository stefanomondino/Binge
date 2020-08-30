//
//  ShowDetailUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

protocol ItemDetailViewModel: RxListViewModel, RxNavigationViewModel {
    var routeFactory: RouteFactory { get }
    var title: String { get }
    var navbarTitleViewModel: Observable<ViewModel?> { get }
    var backgroundImage: ObservableImage { get }
    func selectItem(at _: IndexPath)
    func navigate(to item: TraktItemContainer)
    func addToFavorite()
    var isLoading: Observable<Bool> { get }
}

extension ItemDetailViewModel {
    func navigate(to item: TraktItemContainer) {
        switch item {
        case let show as TraktShowItem:
            routes.accept(routeFactory.showDetail(for: show))
        case let movie as TraktMovieItem:
            routes.accept(routeFactory.showDetail(for: movie))
        case let person as Trakt.Person:
            routes.accept(routeFactory.personDetail(for: person))
        default: break
        }
    }
}
