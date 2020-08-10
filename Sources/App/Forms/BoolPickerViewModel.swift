//
//  BoolPickerViewModel.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import RxCocoa
import RxRelay
import RxSwift

class BoolPickerViewModel: FormViewModel {
    var uniqueIdentifier: UniqueIdentifier = UUID()

    var onNext: NavigationCallback?

    var onPrevious: NavigationCallback?

    var focus: PublishRelay<Void> = PublishRelay()

    let value: BehaviorRelay<Bool?>
    let validate: ValidationCallback
    let layoutIdentifier: LayoutIdentifier

    var additionalInfo: FormAdditionalInfo

    init(relay: BehaviorRelay<Bool?>,
         layout: LayoutIdentifier = ViewIdentifier.stringPicker,
         info: FormAdditionalInfo,
         validating validate: @escaping ValidationCallback = { _ in nil }) {
        value = relay
        self.validate = validate
        additionalInfo = info
        layoutIdentifier = layout
    }
}
