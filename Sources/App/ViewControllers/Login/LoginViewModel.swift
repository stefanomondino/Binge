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
    
    let layoutIdentifier: LayoutIdentifier

    init() {
        self.layoutIdentifier = SceneIdentifier.login
    }
    func reload() {
        let name = BehaviorRelay<String?>(value: nil)
        let nameVM = StringPickerViewModel(relay: name)
        
        let password = BehaviorRelay<String?>(value: "")
        let passwordVM = StringPickerViewModel(relay: password)
                
        let multiValue = BehaviorRelay<ListItemViewModel?>(value: nil)
        let values = (0..<100).map { ListItemViewModel(title: "\($0)") }
        let multi = ListPickerViewModel(items: .just(values), value: multiValue, layout: ViewIdentifier.stringPicker)
        
        let items: [FormViewModelType] = [nameVM,multi, passwordVM].withNavigation {
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
    var layoutIdentifier: LayoutIdentifier = ViewIdentifier.header
    var description: String
    init(title: String) {
        self.description = title
    }
}
