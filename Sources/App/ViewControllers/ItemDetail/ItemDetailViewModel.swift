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
    var navbarTitleViewModel: Observable<ViewModel?> { get }
    var backgroundImage: ObservableImage { get }
    func selectItem(at _: IndexPath)
    func navigate(to item: ItemContainer)
    func addToFavorite()
}

extension ItemDetailViewModel {
    func navigate(to item: ItemContainer) {
        switch item {
        case let show as ShowItem:
            routes.accept(routeFactory.showDetail(for: show))
        case let movie as MovieItem:
            routes.accept(routeFactory.showDetail(for: movie))
        case let person as Person:
            routes.accept(routeFactory.personDetail(for: person))
        default: break
        }
    }
}
