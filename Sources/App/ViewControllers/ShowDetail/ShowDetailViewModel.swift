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
        
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.showDetail
    
    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCaseType
    
    let styleFactory: StyleFactory
    
    let show: WithShow
    
    init(
        show: WithShow,
        itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowDetailUseCaseType,
         styleFactory: StyleFactory) {
        self.show = show
        self.useCase = useCase
        self.styleFactory = styleFactory
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
        useCase.showDetail(for: show.show)
        .map(map(_:))
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
    }
    
    func map(_ show: ShowDetail) -> [Section] {
        return [Section(id:"",items:[itemViewModelFactory.show(show.show)])]
    }
    
    func selectItem(at indexPath: IndexPath) {
    
    }        
}
