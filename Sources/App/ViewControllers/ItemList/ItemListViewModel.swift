//
//  ShowListViewModel.swift
//  App
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

extension PageInfo {
    var title: Translation {
        switch self {
        case .popular: return Strings.Shows.popular
        case .trending: return Strings.Shows.trending
        case .watched: return Strings.Shows.watched
        case .collected: return Strings.Shows.collected
        case .anticipated: return Strings.Shows.anticipated
        }
    }
}

class ItemListViewModel: RxListViewModel, RxNavigationViewModel, WithPage {
    let uniqueIdentifier: UniqueIdentifier = UUID()

    var routes: PublishRelay<Route> = PublishRelay()

    typealias ShowListDownloadClosure = (_ current: Int, _ total: Int) -> Observable<[ItemContainer]>

    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier

//    let downloadClosure: ShowListDownloadClosure
    let itemViewModelFactory: ItemViewModelFactory

    var pageTitle: String { useCase.page.title.description }

    var pageIcon: UIImage? {
        return nil
    }

//    init(itemViewModelFactory: ItemViewModelFactory,
//         downloadClosure: @escaping ShowListDownloadClosure) {
//        self.downloadClosure = downloadClosure
//        self.itemViewModelFactory = itemViewModelFactory
//    }
    private let useCase: ItemListUseCase

    let routeFactory: RouteFactory

    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: ItemListUseCase,
         routeFactory: RouteFactory,
         layout: SceneIdentifier = SceneIdentifier.itemList) {
        self.useCase = useCase
        self.routeFactory = routeFactory
        layoutIdentifier = layout
        self.itemViewModelFactory = itemViewModelFactory
    }

    func reload() {
        disposeBag = DisposeBag()
        sections = createSections(from: [])
    }

    func selectItem(at indexPath: IndexPath) {
        guard let show = (self[indexPath] as? ShowItemViewModel)?.item else { return }
        let route = routeFactory.showDetail(for: show)
        routes.accept(route)
    }

    private func items(from items: [ItemContainer]) -> [ViewModel] {
        let factory = itemViewModelFactory
        return items.map { factory.item($0, layout: .posterOnly) }
    }

    private func addItems(from shows: [ItemContainer]) {
        guard var section = sections.first else { return }
        let newItems = items(from: shows)
        section.items = section.items.dropLast()
        if newItems.isEmpty == false {
            section.items += newItems + [loadMore()]
        }
        sections = [section]
    }

    private func loadMore() -> ViewModel {
        return itemViewModelFactory.loadMore { [weak self] () -> Disposable in
            guard let self = self, let section = self.sections.first else { return Disposables.create() }

            let currentPage = section.items.count / 20
            return self.useCase
                .items(currentPage: currentPage + 1, pageSize: 20)
//                .downloadClosure(currentPage + 1, 20)
                .share()
                .do(onNext: self.addItems(from:))
                .subscribe()
        }
    }

    private func createSections(from shows: [Item]) -> [Section] {
        let items = self.items(from: shows) + [loadMore()]
        return [Section(items: items)]
    }
}
