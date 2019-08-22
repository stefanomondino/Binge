//
//  ShowListViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift

/**
    A Boomerang ListViewModel for ShowList entity contents.

    It should handle data from ModelLayer, into group it into sections of data values and lazily convert them into ItemViewModels
*/

public class ShowListViewModel: ListViewModelType, SceneViewModelType, InteractionViewModelType, PageViewModelType {
    public var mainTitle: String
    

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.showList
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var selection: Selection = .empty
    
    public var title: String = ""
    
    init() {
        //Use proper UseCase from Model
        let pageSize = 100
        self.mainTitle = "Trending"
       
        let observable: Observable<DataGroup> =  .deferred { [weak self] in
            guard let self = self else { return .empty() }
            let loadMore = self.loadMoreItem(pageSize: pageSize, {
                UseCases.trending.trending(currentPage: $0, pageSize: pageSize).map { $0 }.delaySubscription(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            })
            let startGroup = DataGroup([loadMore])
            return .just(DataGroup(groups: [startGroup]))
        }
        
        self.dataHolder = DataHolder(data: observable)
        self.selection = defaultSelection()
    }

    
    public func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        switch model {
        case let model as TrendingShow : return ShowItemViewModel(trending: model) 
        default: return nil
        }
    }
    
    public func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {
        
//        if let model = self.dataHolder[indexPath] as? DataValue.Element {
//            //Create some route here, or whatever needed
//            //return Observable.just(.route(NavigationRoute(viewModel: SomeViewModel())))
//        }
        return .empty()
    }
}
