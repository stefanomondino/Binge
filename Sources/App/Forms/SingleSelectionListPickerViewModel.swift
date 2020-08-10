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

class SingleSelectionListPickerViewModel<Element: ViewModel & Hashable & CustomStringConvertible>: ListPickerViewModel<Element>, FormViewModel {
    var validate: ValidationCallback = { _ in nil }

    let value: BehaviorRelay<Element?>
    private let selectedValue: BehaviorRelay<Element?>
    var focus = PublishRelay<Void>()

    var onNext: NavigationCallback?

    var onPrevious: NavigationCallback?

    let additionalInfo: FormAdditionalInfo

    init(items: Observable<[Element]>,
         value: BehaviorRelay<Element?>,
         info: FormAdditionalInfo,
         layout: LayoutIdentifier) {
        additionalInfo = info
        self.value = value
        selectedValue = BehaviorRelay(value: value.value)
        super.init(items: items, layout: layout)
    }

    func clear() {
        value.accept(nil)
    }

    func confirm() {
        value.accept(selectedValue.value)
    }

    override func selectItem(at indexPath: IndexPath) {
        super.selectItem(at: indexPath)
        if let element = self[indexPath] as? Element {
            selectedValue.accept(element)
        }
    }
}
