//
//  ShowPagesViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift

/**
    A Boomerang ListViewModel for ShowPages entity contents.

    It should handle data from ModelLayer, into group it into sections of data values and lazily convert them into ItemViewModels
*/

public class ShowPagesViewModel: ListViewModelType, SceneViewModelType, InteractionViewModelType {

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.showPages
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var selection: Selection = .empty
    
    public var title: String = ""
    
    init() {
        //Use proper UseCase from Model
        //self.dataHolder = DataHolder(data: group(UseCases.start.start()))
        let pages =  [ShowListViewModel()]
        self.dataHolder = DataHolder(data: .just(DataGroup(pages)))
        self.selection = defaultSelection()
    }

    public func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        switch model {

        default: return nil
        }
    }
    
    public func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {
        return .empty()
    }
}
