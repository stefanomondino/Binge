//
//  PersonUseCaseViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class PersonViewModel: RxListViewModel, RxNavigationViewModel {
    let uniqueIdentifier: UniqueIdentifier = UUID()
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    var routes: PublishRelay<Route> = PublishRelay()
    var disposeBag: DisposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.person

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: PersonDetailUseCase

    let styleFactory: StyleFactory
    let person: Person

    init(person: Person,
         itemViewModelFactory: ItemViewModelFactory,
         useCase: PersonDetailUseCase,
         styleFactory: StyleFactory) {
        self.useCase = useCase
        self.person = person
        self.styleFactory = styleFactory
        self.itemViewModelFactory = itemViewModelFactory
    }

    func reload() {
        disposeBag = DisposeBag()
        useCase
            .personDetail(for: person)
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
    }

    func selectItem(at _: IndexPath) {}
}
