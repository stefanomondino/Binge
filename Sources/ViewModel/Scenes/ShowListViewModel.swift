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

public class ShowListViewModel: ListViewModelType, SceneViewModelType, InteractionViewModelType, PageViewModel {
    public var mainTitle: String

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.showList
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var selection: Selection = .empty
    
    public var title: String = ""
    
    static func trending() -> ShowListViewModel {
        return ShowListViewModel(title: .trending) {
            UseCases.trending.trending(currentPage: $0, pageSize: $1).map { $0 }
        }
    }
    static func popular() -> ShowListViewModel {
        return ShowListViewModel(title: .popular) {
            UseCases.trending.popular(currentPage: $0, pageSize: $1).map { $0 }
        }
    }
    static func played() -> ShowListViewModel {
        return ShowListViewModel(title: .played) {
            UseCases.trending.played(currentPage: $0, pageSize: $1).map { $0 }
        }
    }
    static func watched() -> ShowListViewModel {
        return ShowListViewModel(title: .watched) {
            UseCases.trending.watched(currentPage: $0, pageSize: $1).map { $0 }
        }
    }
    static func collected() -> ShowListViewModel {
        return ShowListViewModel(title: .collected) {
            UseCases.trending.collected(currentPage: $0, pageSize: $1).map { $0 }
        }
    }
    init(title: Identifiers.Strings, paginatedObservable: @escaping (Int, Int) -> Observable<[WithShow]>) {
        
        //Use proper UseCase from Model
        let pageSize = 10
        self.mainTitle = title.translation
       
        let observable: Observable<DataGroup> =  .deferred { [weak self] in
            guard let self = self else { return .empty() }
            
            let loadMore = self.loadMoreItem(pageSize: pageSize, { [weak self] in
                let items = self?.dataHolder.count ?? 0
                let page = Int(ceil(CGFloat(items) / CGFloat(pageSize))) + 1
                return paginatedObservable(page, pageSize).map { $0 }.delaySubscription(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
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
        case let model as PlayedShow : return ShowItemViewModel(popular: model)
        case let model as Show : return ShowItemViewModel(show: model) 
        default: return nil
        }
    }
    
    public func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {
        
        switch self.dataHolder[indexPath] {
        case let item as WithShow: return .just(.route(NavigationRoute(viewModel: ShowDetailViewModel(show: item.show))))
        default: break
        }
        
//        if let model = self.dataHolder[indexPath] as? DataValue.Element {
//            //Create some route here, or whatever needed
//            //return Observable.just(.route(NavigationRoute(viewModel: SomeViewModel())))
//        }
        return .empty()
    }
}
