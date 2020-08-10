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

class MultipleSelectionListPickerViewModel<Element: ViewModel & Hashable & CustomStringConvertible>: ListPickerViewModel<Element>, FormViewModel {
    let value: BehaviorRelay<[Element]?>
    var validate: ValidationCallback = { _ in nil }

    var focus = PublishRelay<Void>()

    var onNext: NavigationCallback?

    var onPrevious: NavigationCallback?

    let additionalInfo: FormAdditionalInfo

    private let indexPaths = BehaviorRelay<Set<IndexPath>>(value: Set([]))

    var selectedItems: Observable<[Element]> {
        indexPaths.map { [weak self] indexes in
            indexes.compactMap { index in self?[index] as? Element }
        }
    }

    init(items: Observable<[Element]>,
         value: BehaviorRelay<[Element]?>,
         info: FormAdditionalInfo,
         layout: LayoutIdentifier) {
        additionalInfo = info
        self.value = value
        super.init(items: items, layout: layout)
    }

    func clear() {
        value.accept(nil)
    }

    override func selectItem(at indexPath: IndexPath) {
        var indices = indexPaths.value
        if indices.contains(indexPath) {
            indices.remove(indexPath)
        } else {
            indices.insert(indexPath)
        }
        indexPaths.accept(indices)
    }

    func confirm() {
        selectedItems
            .take(1)
            .bind(to: value)
            .disposed(by: disposeBag)
    }
}
