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

    typealias ShowListDownloadClosure = (_ current: Int, _ total: Int) -> Observable<[TraktItemContainer]>

    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var disposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier

//    let downloadClosure: ShowListDownloadClosure
    let itemViewModelFactory: ItemViewModelFactory

    var pageTitle: String { useCase.page.title.description }

    var pageIcon: UIImage? {
        return nil
    }

    private let loadingRelay = BehaviorRelay(value: false)
    var isLoading: Observable<Bool> { loadingRelay.asObservable() }

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
        guard let show = (self[indexPath] as? GenericItemViewModel)?.item as? TraktItemContainer else { return }
        let route = routeFactory.showDetail(for: show)
        routes.accept(route)
    }

    private func items(from items: [TraktItemContainer]) -> [ViewModel] {
        let factory = itemViewModelFactory
        return items.map { factory.item($0, layout: .posterOnly) }
    }

    func openSearch() {
        routes.accept(routeFactory.search())
    }

    private func addItems(from shows: [TraktItemContainer]) {
        guard var section = sections.first else { return }
        let newItems = items(from: shows)
        section.items = section.items.dropLast()
        if newItems.isEmpty == false {
            section.items += newItems + [loadMore()]
        }
        sections = [section]
    }

    private let loadMoreEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    private func loadMore() -> ViewModel {
        return itemViewModelFactory.loadMore { [weak self] () -> Disposable in
            guard let self = self else { return Disposables.create() }

            return self.loadMoreEnabled
                .filter { $0 }
                .take(1)
//                .delay(.milliseconds(100), scheduler: Scheduler.background)
                .flatMapLatest { [weak self] _ -> Observable<[TraktItemContainer]> in
                    guard
                        let self = self,
                        let section = self.sections.first else { return Observable.empty() }
                    let currentPage = section.items.count / 20
                    let useCase = self.useCase
                    let trigger = self.loadMoreEnabled
                    Logger.log(currentPage)
                    return useCase
                        .items(currentPage: currentPage + 1, pageSize: 20)
                        .takeLast(1)
                        .debug("TESTING")
                        .do(onNext: { [weak self] in self?.addItems(from: $0) },
                            onSubscribe: { trigger.accept(true) },
                            onDispose: { trigger.accept(true) })
                }
                .subscribe()
        }
    }

    private func createSections(from shows: [TraktItem]) -> [Section] {
        let items = self.items(from: shows) + [loadMore()]
        return [Section(id: "", items: items)]
    }
}
