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
    var navbarTitleViewModel: Observable<ViewModel?> { get }
    var backgroundImage: ObservableImage { get }
    func selectItem(at _: IndexPath)
    func addToFavorite()
}
