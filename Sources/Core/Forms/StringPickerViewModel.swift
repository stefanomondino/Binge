//
//  StringPickerViewModel.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import RxCocoa

class StringPickerViewModel: FormViewModel {
    var onNext: NavigationCallback?
    
    var onPrevious: NavigationCallback?
    
    var focus: PublishRelay<()> = PublishRelay()
    
    let value: BehaviorRelay<String?>
    let validate: (String?) -> Error?
    let layoutIdentifier: LayoutIdentifier
    let additionalInfo: FormAdditionalInfo
    init(relay: BehaviorRelay<String?>,
         layout: LayoutIdentifier,
         info: FormAdditionalInfo,
         validating validate: @escaping ValidationCallback = {_ in nil } ) {
        self.value = relay
        self.additionalInfo = info
        self.validate = validate
        self.layoutIdentifier = layout
    }
    
}


class ListPickerViewModel<Element: ViewModel & Hashable & CustomStringConvertible>: RxListViewModel, FormViewModel {

    
    var validate: ValidationCallback = { _ in nil}
        
    let value: BehaviorRelay<Element?>
    
    var focus = PublishRelay<()>()
    
    var onNext: NavigationCallback?
    
    var onPrevious: NavigationCallback?
    
    let sectionsRelay = BehaviorRelay<[Section]>(value: [])
    
    let additionalInfo: FormAdditionalInfo
    
    func reload() {
        self.disposeBag = DisposeBag()
        self.items
            .catchErrorJustReturn([])
            .map { [Section(id: "section", items: $0)]}
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {
        self.value.accept(self[indexPath] as? Element)
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier
    let items: Observable<[Element]>
    init(items: Observable<[Element]>,
         value: BehaviorRelay<Element?>,
         info: FormAdditionalInfo,
         layout: LayoutIdentifier) {
        self.layoutIdentifier = layout
        self.items = items
        self.additionalInfo = info
        self.value = value
    }
    
}
