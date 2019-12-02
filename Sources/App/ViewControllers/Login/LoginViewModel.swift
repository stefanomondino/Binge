//
//  LoginViewModel.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxRelay
import RxCocoa
import RxSwift

class LoginViewModel: RxListViewModel, WithPage {
    var pageTitle: String = "Login"
    
    var pageIcon: UIImage?
    
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()

    func reload() {
        let name = BehaviorRelay(value: "")
        let viewModel = StringPickerViewModel(relay: name)
        
        self.sections = [Section(id: "test", items:[viewModel])]
        
        
    }
    
    func selectItem(at indexPath: IndexPath) {
        
    }
    
    var layoutIdentifier: LayoutIdentifier
    
    
    init() {
        self.layoutIdentifier = SceneIdentifier.login
    }
}
