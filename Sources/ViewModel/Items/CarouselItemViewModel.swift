//
//  CarouselItemViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxCocoa

/**
 A Boomerang ItemViewModel for Carousel entity contents.
 
 Should convert provided entity in order to implement presentation business logic and exposing ready-to-be-displayed values to bounded views.
 */

public class CarouselItemViewModel: ItemViewModelType, ListViewModelType, InteractionViewModelType {
    public var selection: Selection = .empty
    public var externalSelection: Selection?
    
    public var dataHolder: DataHolder  = DataHolder()
    
    public let identifier: Identifier = Identifiers.Views.carousel
    public var size: CarouselSize = .default
    public var backgroundColor: Color = .clear
    
    init(data: [DataType], externalSelection: Selection? = nil) {
        self.selection = defaultSelection()
        dataHolder = DataHolder(data: .just(DataGroup(data)))
    }
    
    public func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {        
        guard let model = dataHolder[indexPath] else {
            return.empty()
        }
        
        switch  model {
//        case let model as DataType:
//            externalSelection?.execute(.route(NavigationRoute(viewModel: SomeViewModel(from: model))))
        
        default:
            return.empty()
        }
    }

    public func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        switch model {
//        case let model as DataType:
//            return SomeItemViewModel(value: model)
        default:
            return nil
        }
    }
}

public enum CarouselSize {
    case `default`
}

extension CarouselSize {
    public func height() -> CGFloat {
        switch self {
        default:
            return 200
        }
    }
    
    public func itemsPerLine() -> Int {
        switch self {
        default: return 2
        }
    }
}
