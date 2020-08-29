//
//  ListPickerViewModel.swift
//  Skeleton
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Boomerang
import Foundation
import RxRelay
import RxSwift

class SingleSelectionListPickerViewModel<Element: ViewModel & Hashable & CustomStringConvertible>: ListPickerViewModel<Element>, FormViewModel, DetailedFormViewModel, WithPage {
    var validate: ValidationCallback = { _ in nil }

    let value: BehaviorRelay<Element?>
    private let selectedValue: BehaviorRelay<Element?>
    var focus = PublishRelay<Void>()
    var pageIcon: UIImage?
    var pageTitle: String
    var onNext: NavigationCallback?

    var onPrevious: NavigationCallback?
    let routeFactory: RouteFactory
    let additionalInfo: FormAdditionalInfo
    private let routes: PublishRelay<Route>
    init(items: Observable<[Element]>,
         value: BehaviorRelay<Element?>,
         title: String,
         info: FormAdditionalInfo,
         layout: LayoutIdentifier,
         routeFactory: RouteFactory,
         routes: PublishRelay<Route>) {
        additionalInfo = info
        self.value = value
        pageTitle = title
        self.routes = routes

        self.routeFactory = routeFactory
        selectedValue = BehaviorRelay(value: value.value)
        super.init(items: items, layout: layout)
    }

    func clear() {
        value.accept(nil)
    }

    func confirm() {
        value.accept(selectedValue.value)
    }

    func open() {
        let route = routeFactory.settingsList(viewModel: self)
        routes.accept(route)
    }

    override func selectItem(at indexPath: IndexPath) {
        super.selectItem(at: indexPath)
        if let element = self[indexPath] as? Element {
            selectedValue.accept(element)

            confirm()
        }
    }
}
