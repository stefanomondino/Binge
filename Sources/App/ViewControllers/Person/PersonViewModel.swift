//
//  PersonUseCaseViewModel.swift
//  App
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class PersonViewModel: RxListViewModel, RxNavigationViewModel {
        
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
            .personDetail(for: self.person)
            .debug()
            .subscribe()
        .disposed(by: disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {
    
    }        
}
