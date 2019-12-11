
//
//  PageViewModel.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxSwift
import RxRelay

class PagerViewModel: RxListViewModel, WithPage {
    var pageTitle: String = ""
    
    var pageIcon: UIImage? = nil
    
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value:[])
    
    var disposeBag: DisposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier
    
    var onUpdate = {}
//    var sections: [Section] = [] {
//        didSet {
//            self.onUpdate()
//        }
//    }
    private let pages: Observable<[ViewModel]>
    let styleFactory: StyleFactory
    
    convenience init(pages: [ViewModel],
                     layout: LayoutIdentifier = SceneIdentifier.pager,
                     styleFactory: StyleFactory) {
        self.init(pages: .just(pages), layout: layout, styleFactory: styleFactory)
    }
    
    init(pages: Observable<[ViewModel]>,
         layout: LayoutIdentifier = SceneIdentifier.pager,
         styleFactory: StyleFactory) {
           self.pages = pages
            self.layoutIdentifier = layout
           self.styleFactory = styleFactory
    }
    func reload() {
        self.disposeBag = DisposeBag()
        pages
            .map { [Section(items: $0)] }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }
    func selectItem(at indexPath: IndexPath) {}
}
