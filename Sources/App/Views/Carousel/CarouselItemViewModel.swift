//
//  CarouselViewModel.swift
//  App
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxRelay

class CarouselItemViewModel: RxListViewModel {
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    func reload() {
        self.disposeBag = DisposeBag()
        self.observable
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {}
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID()
    
    let styleFactory: StyleFactory
    let cellFactory: CollectionViewCellFactory
    
    private let observable: Observable<[Section]>
    init(sections: Observable<[Section]>,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.carousel,
         cellFactory: CollectionViewCellFactory,
         styleFactory: StyleFactory) {
        self.observable = sections
        self.cellFactory = cellFactory
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        
        reload()
    }
}
