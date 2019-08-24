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

public class ShowPagesViewModel: ListViewModelType, SceneViewModelType, InteractionViewModelType, PageViewModel {
    public var mainTitle: String { return sceneTitle }

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.showPages
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var selection: Selection = .empty
    
    public var title: String = ""
    
    public var sceneTitle: String = Identifiers.Strings.shows.translation
    
    public var pageTitle: Observable<String> {
        return .just(sceneTitle)
    }
    
    init() {
        //Use proper UseCase from Model
        //self.dataHolder = DataHolder(data: group(UseCases.start.start()))
        let pages =  [ShowListViewModel.trending(),
                      ShowListViewModel.popular(),
                      ShowListViewModel.played(),
                      ShowListViewModel.watched(),
                    ShowListViewModel.collected()
        ]
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
