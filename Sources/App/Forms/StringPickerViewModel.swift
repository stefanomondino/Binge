//
//  StringPickerViewModel.swift
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

class StringPickerViewModel: FormViewModel {
    var onNext: NavigationCallback?

    var onPrevious: NavigationCallback?

    var focus: PublishRelay<Void> = PublishRelay()
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let value: BehaviorRelay<String?>
    let validate: (String?) -> Error?
    let layoutIdentifier: LayoutIdentifier
    let additionalInfo: FormAdditionalInfo
    init(relay: BehaviorRelay<String?>,
         layout: LayoutIdentifier = ViewIdentifier.stringPicker,
         info: FormAdditionalInfo,
         validating validate: @escaping ValidationCallback = { _ in nil }) {
        value = relay
        additionalInfo = info
        self.validate = validate
        layoutIdentifier = layout
    }
}
