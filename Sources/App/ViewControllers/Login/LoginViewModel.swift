//
//  LoginUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class LoginViewModel: RxListViewModel, RxNavigationViewModel, WithPage {
    var routes: PublishRelay<Route> = PublishRelay()

    var uniqueIdentifier: UniqueIdentifier = UUID()

    var pageTitle: String = "Login"

    var pageIcon: UIImage?

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    let layoutIdentifier: LayoutIdentifier
    let itemFactory: PickerViewModelFactory

    init(itemFactory: PickerViewModelFactory,
         routeFactory _: RouteFactory,
         styleFactory _: StyleFactory) {
        self.itemFactory = itemFactory
        layoutIdentifier = SceneIdentifier.login
    }

    func reload() {
        let name = BehaviorRelay<String?>(value: nil)
        let nameVM = itemFactory.email(relay: name, title: "name")

        let password = BehaviorRelay<String?>(value: "")
        let passwordVM = itemFactory.password(relay: password, title: "password")

        let items: [FormViewModelType] = [nameVM, passwordVM].withNavigation {
            print("Final element in form")
        }

        sections = [Section(id: "test", items: items)]
    }

    func selectItem(at _: IndexPath) {}
}

class ListItemViewModel: ViewModel, CustomStringConvertible, Hashable {
    var uniqueIdentifier: UniqueIdentifier = UUID()

    static func == (lhs: ListItemViewModel, rhs: ListItemViewModel) -> Bool {
        lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    var layoutIdentifier: LayoutIdentifier = ViewIdentifier.header
    var description: String
    init(title: String) {
        description = title
    }
}
