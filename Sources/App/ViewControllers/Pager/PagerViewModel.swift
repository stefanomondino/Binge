
//
//  PageViewModel.swift
//  App
//
//  Created by Stefano Mondino on 23/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

class PagerViewModel: ListViewModel {

    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.pager
    
    var onUpdate = {}
    var sections: [Section] = [] {
        didSet {
            self.onUpdate()
        }
    }
    private let pages: [ViewModel]
    init(pages: [ViewModel]) {
        self.pages = pages
    }
    func reload() {
        self.sections = [Section(items: pages)]
    }
    func selectItem(at indexPath: IndexPath) {}
}

