//
//  CarouselViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class CarouselItemViewModel: RxListViewModel {
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    func reload() {
        disposeBag = DisposeBag()
        observable
            .catchErrorJustReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    var disposeBag: DisposeBag = DisposeBag()

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID()

    let styleFactory: StyleFactory
    let cellFactory: CollectionViewCellFactory

    private let onSelection: (ViewModel) -> Void

    private let observable: Observable<[Section]>
    init(sections: Observable<[Section]>,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.carousel,
         cellFactory: CollectionViewCellFactory,
         styleFactory: StyleFactory,
         onSelection: @escaping (ViewModel) -> Void = { _ in }) {
        observable = sections
        self.cellFactory = cellFactory
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        self.onSelection = onSelection
        reload()
    }

    public func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] {
            onSelection(viewModel)
        }
    }
}
