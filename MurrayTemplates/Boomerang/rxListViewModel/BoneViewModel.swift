//
//  {{ name|firstUppercase }}UseCaseViewModel.swift
//  {{ target }}
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class {{ name|firstUppercase }}ViewModel: RxListViewModel {
        
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.{{ name|firstLowercase }}
    
    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: {{ name|firstUppercase }}UseCase
    
    let styleFactory: StyleFactory
    
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: {{ name|firstUppercase }}UseCase,
         styleFactory: StyleFactory) {
        self.useCase = useCase
        self.styleFactory = styleFactory
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
		//Bind here to use case and set sectionsRelay
    }
    
    func selectItem(at indexPath: IndexPath) {
    
    }        
}
