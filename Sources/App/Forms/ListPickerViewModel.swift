//
//  ListPickerViewModel.swift
//  Skeleton
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Boomerang
import Foundation
import RxRelay
import RxSwift

open class ListPickerViewModel<ListElement: ViewModel>: RxListViewModel {
    public var uniqueIdentifier: UniqueIdentifier = UUID()
    public let sectionsRelay = BehaviorRelay<[Section]>(value: [])
    public var reloadDisposeBag: DisposeBag = DisposeBag()
    public var layoutIdentifier: LayoutIdentifier
    public let items: Observable<[ListElement]>
    public var disposeBag: DisposeBag = DisposeBag()
    public init(items: Observable<[ListElement]>,
                layout: LayoutIdentifier) {
        layoutIdentifier = layout
        self.items = items
    }

    open func reload() {
        reloadDisposeBag = DisposeBag()
        items
            .catchErrorJustReturn([])
            .map { [Section(id: UUID().uuidString, items: $0)] }
            .bind(to: sectionsRelay)
            .disposed(by: reloadDisposeBag)
    }

    open func selectItem(at _: IndexPath) {}
}
