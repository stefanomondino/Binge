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

class SearchViewModel: RxListViewModel, RxNavigationViewModel, WithPage {
    let uniqueIdentifier: UniqueIdentifier = UUID()

    var routes: PublishRelay<Route> = PublishRelay()

    typealias ShowListDownloadClosure = (_ current: Int, _ total: Int) -> Observable<[ItemContainer]>

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    var layoutIdentifier: LayoutIdentifier

//    let downloadClosure: ShowListDownloadClosure
    let itemViewModelFactory: ItemViewModelFactory

    var pageTitle: String { "Search" }

    var pageIcon: UIImage? {
        return nil
    }

    private let useCase: SearchUseCase

    let searchRelay = BehaviorRelay<String?>(value: "Lost")

    let routeFactory: RouteFactory

    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: SearchUseCase,
         routeFactory: RouteFactory,
         layout: SceneIdentifier = SceneIdentifier.search) {
        self.useCase = useCase
        self.routeFactory = routeFactory
        layoutIdentifier = layout
        self.itemViewModelFactory = itemViewModelFactory
    }

    func reload() {
        disposeBag = DisposeBag()
        searchRelay
            .asObservable()

            .map { ($0 ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: Scheduler.background)
            .map { [weak self] query in
                self?.createSections(from: [], query: query) ?? []
            }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func selectItem(at indexPath: IndexPath) {
        guard let show = (self[indexPath] as? ShowItemViewModel)?.item else { return }
        let route = routeFactory.showDetail(for: show)
        routes.accept(route)
    }

    private func items(from items: [ItemContainer]) -> [ViewModel] {
        let factory = itemViewModelFactory
        return items.map { factory.item($0, layout: .full) }
    }

    private func addItems(from shows: [ItemContainer], query: String) {
        guard var section = sections.first else { return }
        let newItems = items(from: shows)
        section.items = section.items.dropLast()
        if newItems.isEmpty == false {
            section.items += newItems + [loadMore(query: query)]
        }
        sections = [section]
    }

    private let loadMoreEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    private func loadMore(query: String) -> ViewModel {
        return itemViewModelFactory.loadMore { [weak self] () -> Disposable in
            guard let self = self else { return Disposables.create() }

            return self.loadMoreEnabled
                .filter { $0 }
                .take(1)
//                .delay(.milliseconds(100), scheduler: Scheduler.background)
                .flatMapLatest { [weak self] _ -> Observable<[ItemContainer]> in
                    guard
                        let self = self,
                        let section = self.sections.first else { return Observable.empty() }
                    let currentPage = section.items.count / 20
                    let useCase = self.useCase
                    let trigger = self.loadMoreEnabled

                    Logger.log(currentPage)
                    return useCase
                        .items(query: query, currentPage: currentPage + 1, pageSize: 20)
                        .debug()
                        .takeLast(1)
                        .do(onNext: { [weak self] in self?.addItems(from: $0, query: query) },
                            onSubscribe: { trigger.accept(true) },
                            onDispose: { trigger.accept(true) })
                }
                .subscribe()
        }
    }

    private func createSections(from shows: [Item], query: String) -> [Section] {
        let items = query.isEmpty ? [] : self.items(from: shows) + [loadMore(query: query)]
        return [Section(id: "", items: items)]
    }
}
