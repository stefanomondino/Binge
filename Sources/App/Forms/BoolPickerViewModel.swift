//
//  BoolPickerViewModel.swift
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

class BoolPickerViewModel: FormViewModel {
    var onNext: NavigationCallback?
    
    var onPrevious: NavigationCallback?
    
    var focus: PublishRelay<()> = PublishRelay()
    
    let value: BehaviorRelay<Bool?>
    let validate: ValidationCallback
    let layoutIdentifier: LayoutIdentifier
    
    init(relay: BehaviorRelay<Bool?>,
         layout: LayoutIdentifier = ViewIdentifier.stringPicker,
         validating validate: @escaping ValidationCallback = {_ in nil } ) {
        self.value = relay
        self.validate = validate
        self.layoutIdentifier = layout
    }
    
}
