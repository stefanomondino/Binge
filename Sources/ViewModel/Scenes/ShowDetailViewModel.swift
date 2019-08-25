//
//  ShowDetailViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift

/**
    A Boomerang ListViewModel for ShowDetail entity contents.

    It should handle data from ModelLayer, into group it into sections of data values and lazily convert them into ItemViewModels
*/

public class ShowDetailViewModel: ListViewModelType, SceneViewModelType, InteractionViewModelType {

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.showDetail
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var selection: Selection = .empty
    
    public var title: String = ""
    
    init(show: Show) {
        //Use proper UseCase from Model
        //self.dataHolder = DataHolder(data: group(UseCases.start.start()))
        self.dataHolder = DataHolder(data: UseCases.showDetail.showDetail(for: show).map { detail in
            DataGroup([ShowPosterItemViewModel(show: detail)])
        })
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
