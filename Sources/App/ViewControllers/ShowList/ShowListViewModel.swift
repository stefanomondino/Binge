//
//  ShowListViewModel.swift
//  App
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class ShowListViewModel: RxListViewModel {
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.showList
    
    let useCase: ShowListUseCase
    let itemViewModelFactory: ItemViewModelFactory
    
    init(useCase: ShowListUseCase,
         itemViewModelFactory: ItemViewModelFactory) {
        self.useCase = useCase
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
        let factory = itemViewModelFactory
        
        self.useCase
            .popular(currentPage: 0, pageSize: 20)
            .map { [Section(items: $0.map { factory.show($0)})]}
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {
        
    }
    
    
}
