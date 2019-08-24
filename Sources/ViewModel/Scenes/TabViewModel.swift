//
//  TabViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift

/**
    A Boomerang ListViewModel for Tab entity contents.

    It should handle data from ModelLayer, into group it into sections of data values and lazily convert them into ItemViewModels
*/

public class TabViewModel: ListViewModelType, SceneViewModelType {

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.tab
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var title: String = ""
    
    init() {
        //Use proper UseCase from Model
        //self.dataHolder = DataHolder(data: group(UseCases.start.start()))
        
        let group = DataGroup([ShowPagesViewModel()])
        self.dataHolder = DataHolder(data: .just(group))
        self.load()
    }

    public func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
       return nil
    }
    
}
