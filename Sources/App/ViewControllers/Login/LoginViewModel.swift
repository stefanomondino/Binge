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
import Core

class LoginViewModel: RxListViewModel, WithPage {
    var pageTitle: String = "Login"
    
    var pageIcon: UIImage?
    
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let layoutIdentifier: LayoutIdentifier
    let itemFactory: PickerViewModelFactory
    init(itemFactory: PickerViewModelFactory) {
        self.itemFactory = itemFactory
        self.layoutIdentifier = SceneIdentifier.login
    }
    func reload() {
        let name = BehaviorRelay<String?>(value: nil)
        let nameVM = itemFactory.email(relay: name, title: "name")
        
        let password = BehaviorRelay<String?>(value: "")
        let passwordVM = itemFactory.password(relay: password, title: "password")
                
    
//        let multiValue = BehaviorRelay<ListItemViewModel?>(value: nil)
//        let values = (0..<100).map { ListItemViewModel(title: "\($0)") }
//        let multi = ListPickerViewModel(items: .just(values), value: multiValue, layout: ViewIdentifier.stringPicker)
        
        let items: [FormViewModelType] = [nameVM, passwordVM].withNavigation {
            print("Final element in form")
        }
            
        self.sections = [Section(id: "test", items:items)]
    }
    
    func selectItem(at indexPath: IndexPath) {}

}

class ListItemViewModel: ViewModel, CustomStringConvertible, Hashable {
    static func == (lhs: ListItemViewModel, rhs: ListItemViewModel) -> Bool {
        lhs.description == rhs.description
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
    var layoutIdentifier: LayoutIdentifier
    var description: String
    init(title: String, layout: LayoutIdentifier) {
        self.description = title
        self.layoutIdentifier = layout
    }
}
