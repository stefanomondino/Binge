//
//  LoadMoreItemViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift
/**
    A Boomerang ItemViewModel for LoadMore entity contents.

    Should convert provided entity in order to implement presentation business logic and exposing ready-to-be-displayed values to bounded views.
*/
public class LoadMoreItemViewModel: ItemViewModelType {
    public let identifier: Identifier = Identifiers.Views.loadMore
    
    typealias LoadMore = ([EntityType]) -> ()
    ///Example title property. Remove if not needed
    private let observable: Observable<[EntityType]>
    init(observable: Observable<[EntityType]>, closure: @escaping LoadMore) {
        self.observable = observable
            .do(onNext: { closure($0) })
//            .share(replay: 1, scope: .forever)
        
    }
    public func start() -> Disposable {
        return observable.subscribe()
    }
}
