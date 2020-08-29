//
//  SettingsViewModel.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class SettingsViewModel: RxListViewModel, RxNavigationViewModel, WithPage {
    var pageTitle: String = "Settings"

    var pageIcon: UIImage? = Asset.photo.image

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var routes: PublishRelay<Route> = PublishRelay()

    func reload() {
        let themes = pickers.themes(routes: routes)
        sections = [Section(items: [themes])]
    }

    func selectItem(at indexPath: IndexPath) {
        if let picker = self[indexPath]?.as(DetailedFormViewModel.self) {
            picker.open()
        }
    }

    var disposeBag: DisposeBag = DisposeBag()

    var uniqueIdentifier: UniqueIdentifier = UUID()

    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.settings

    let routeFactory: RouteFactory
    let pickers: PickerViewModelFactory
    init(
        pickers: PickerViewModelFactory,
        routeFactory: RouteFactory
    ) {
        self.routeFactory = routeFactory
        self.pickers = pickers
    }
}
