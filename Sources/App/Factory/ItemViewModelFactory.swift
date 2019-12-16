//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxRelay

protocol ItemViewModelFactory {
    //    func header(title: String) -> ViewModel
    func show(_ show: WithShow, layout: ShowIdentifier) -> ViewModel
    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel
    func castCarousel(for show: WithShow, onSelection: @escaping (Person) -> ()) -> ViewModel
    func relatedShowsCarousel(for show: WithShow, onSelection: @escaping (Show) -> ()) -> ViewModel
    func person(_ person: Person) -> ViewModel
    func fanart(_ fanart: Fanart) -> ViewModel
    //MURRAY DECLARATION PLACEHOLDER
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: AppDependencyContainer
    
    func loadMore(_ closure: @escaping () -> Disposable) -> ViewModel {
        LoadMoreItemViewModel(closure)
    }
    
    func show(_ show: WithShow, layout: ShowIdentifier) -> ViewModel {
        ShowItemViewModel(show: show.show,
                          layoutIdentifier: layout,
                          imageUseCase: container.model.useCases.images,
                          styleFactory: container.styleFactory
        )
    }
    
    func castCarousel(for show: WithShow, onSelection: @escaping (Person) -> ()) -> ViewModel {
        let observable = container.model.useCases.showDetail
            .cast(for: show.show)
            .map { $0.map { self.person($0.person) } }
            .map { [Section(items: $0)] }
            .share(replay: 1, scope: .forever)
            
        return CarouselItemViewModel(sections: observable,
                        layoutIdentifier: ViewIdentifier.carousel,
                        cellFactory: container.collectionViewCellFactory,
                        styleFactory: container.styleFactory) { itemViewModel in
                            if let person = (itemViewModel as? PersonItemViewModel)?.person {
                                onSelection(person)
                            }
        }
    }
    
    func relatedShowsCarousel(for show: WithShow, onSelection: @escaping (Show) -> ()) -> ViewModel {
        let observable = container.model.useCases.showDetail
            .related(for: show.show)
            .map { $0.map { self.show($0, layout: .full) } }
            .map { [Section(items: $0)] }
            .share(replay: 1, scope: .forever)
            
        return CarouselItemViewModel(sections: observable,
                        layoutIdentifier: ViewIdentifier.carousel,
                        cellFactory: container.collectionViewCellFactory,
                        styleFactory: container.styleFactory) { itemViewModel in
                            if let show = (itemViewModel as? ShowItemViewModel)?.show {
                                onSelection(show.show)
                            }
        }
    }

    func person(_ person: Person) -> ViewModel {
        PersonItemViewModel(person: person,
                        layoutIdentifier: ViewIdentifier.person,
                        imagesUseCase: container.model.useCases.images,
                        styleFactory: container.styleFactory)
    }

    func fanart(_ fanart: Fanart) -> ViewModel {
        FanartItemViewModel(fanart: fanart,
                        layoutIdentifier: ViewIdentifier.fanart,
                        styleFactory: container.styleFactory)
    }

    //MURRAY IMPLEMENTATION PLACEHOLDER
}
