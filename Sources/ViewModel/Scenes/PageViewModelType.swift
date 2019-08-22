//
//  InteractionViewModelType.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Model

public protocol PageViewModelType: SceneViewModelType {
    var mainTitle: String { get }
    var pageIcon: ObservableImage { get }
}
extension PageViewModelType {
    public var pageIcon: ObservableImage {
        return .empty()
    }
}

extension ListViewModelType where Self: AnyObject {
    func loadMoreItem(pageSize: Int, _ closure: @escaping () -> Observable<[EntityType]>) -> ItemViewModelType {
//        let items = self.dataHolder.count
//        let page = Int(ceil(CGFloat(items) / CGFloat(pageSize)))
        
        return LoadMoreItemViewModel(observable: closure(), closure: { [weak self] downloaded in
            guard let indexPath = self?.dataHolder.indices.last, let self = self else { return }

            self.dataHolder.delete(at: [indexPath], immediate: false)
            if downloaded.count > 0 {
                let elements: [DataType] = downloaded + [self.loadMoreItem(pageSize: pageSize, closure)]
                self.dataHolder.insert(elements, at: indexPath, immediate: false)
            }
        })
    }
}
