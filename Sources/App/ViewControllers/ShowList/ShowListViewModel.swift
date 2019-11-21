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
    
    typealias ShowListDownloadClosure = (_ current: Int, _ total: Int) -> Observable<[WithShow]>
    
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.showList
    
//    let downloadClosure: ShowListDownloadClosure
    let itemViewModelFactory: ItemViewModelFactory
    
//    init(itemViewModelFactory: ItemViewModelFactory,
//         downloadClosure: @escaping ShowListDownloadClosure) {
//        self.downloadClosure = downloadClosure
//        self.itemViewModelFactory = itemViewModelFactory
//    }
    let useCase: ShowListUseCase
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowListUseCase) {
        self.useCase = useCase
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
        self.sections = createSections(from: [])
    }
    
    func selectItem(at indexPath: IndexPath) {
        
    }
    
    private func items(from shows: [WithShow]) -> [ViewModel] {
        return shows.map(itemViewModelFactory.show(_:))
    }
    
    private func addItems(from shows: [WithShow]) {
        guard var section = self.sections.first else { return }
        let newItems = items(from: shows)
        section.items = section.items.dropLast()
        if newItems.isEmpty == false {
            section.items += newItems + [loadMore()]
        }
        self.sections = [section]
    }
    
    private func loadMore() -> ViewModel {
        
        return itemViewModelFactory.loadMore { [weak self] () -> Disposable in
            guard let self = self, let section = self.sections.first else { return Disposables.create() }
            
            let currentPage = section.items.count / 20
            return self.useCase
            .shows(currentPage: currentPage + 1, pageSize: 20)
//                .downloadClosure(currentPage + 1, 20)
                .share()
                .debug()
                .do(onNext: self.addItems(from:))
                .subscribe()
        }
    }
    
    private func createSections(from shows: [Show]) -> [Section] {
        
        let items = self.items(from: shows) + [loadMore()]
        return [Section(items: items)]
    }
    
}
