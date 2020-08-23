//
//  PageViewModel.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxRelay
import RxSwift

class PagerViewModel: RxListViewModel, RxNavigationViewModel, WithPage {
    var routes: PublishRelay<Route> = PublishRelay()

    var pageTitle: String = ""

    var pageIcon: UIImage?

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier

    var uniqueIdentifier: UniqueIdentifier = UUID()

    let isSearchable: Bool

    var onUpdate = {}
//    var sections: [Section] = [] {
//        didSet {
//            self.onUpdate()
//        }
//    }
    private let pages: Observable<[ViewModel]>
    let routeFactory: RouteFactory

    convenience init(pages: [ViewModel],
                     layout: SceneIdentifier,
                     routeFactory: RouteFactory,
                     isSearchable: Bool) {
        self.init(pages: .just(pages), layout: layout, routeFactory: routeFactory, isSearchable: isSearchable)
    }

    init(pages: Observable<[ViewModel]>,
         layout: SceneIdentifier,
         routeFactory: RouteFactory,
         isSearchable: Bool) {
        self.pages = pages
        layoutIdentifier = layout
        self.routeFactory = routeFactory
        self.isSearchable = isSearchable
    }

    func reload() {
        disposeBag = DisposeBag()
        pages
            .map { [Section(items: $0)] }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func openSearch() {
        routes.accept(routeFactory.search())
    }

    func selectItem(at _: IndexPath) {}
}
