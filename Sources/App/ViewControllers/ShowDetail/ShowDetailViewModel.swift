//
//  ShowDetailUseCaseViewModel.swift
//  App
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class ShowDetailViewModel: RxListViewModel {
    typealias ShowDetailUseCase = ShowListUseCase
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.showDetail
    
    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCase
    
    let styleFactory: StyleFactory
    
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowDetailUseCase,
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
