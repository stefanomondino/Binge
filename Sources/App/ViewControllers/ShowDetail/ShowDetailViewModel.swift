//
//  ShowDetailUseCaseViewModel.swift
//  App
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class ShowDetailViewModel: RxListViewModel, RxNavigationViewModel {
        
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var routes: PublishRelay<Route> = PublishRelay()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.showDetail
    
    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCaseType
    
    let styleFactory: StyleFactory
    
    let show: WithShow
    
    let routeFactory: RouteFactory
    
    let backgroundImage: ObservableImage
    
    init(
        show: WithShow,
        routeFactory: RouteFactory,
        itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowDetailUseCaseType,
         styleFactory: StyleFactory) {
        self.show = show
        self.routeFactory = routeFactory
        self.useCase = useCase
        self.styleFactory = styleFactory
        self.itemViewModelFactory = itemViewModelFactory
        self.backgroundImage = useCase
            .fanart(for: show.show)
            .flatMap { $0.image(for: .background)?.getImage() ?? .empty() }
    }
    
    func reload() {
        disposeBag = DisposeBag()
        Observable.combineLatest(useCase.showDetail(for: show.show), useCase.fanart(for: show.show))
        .map { [weak self] in self?.map($0.0, fanart: $0.1) ?? []}
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
    }
    
    func map(_ show: ShowDetail, fanart: FanartResponse) -> [Section] {
        let routes = self.routes
        let routeFactory = self.routeFactory
        let fanarts = Fanart.Format
            .allCases
            .compactMap { fanart.image(for: $0)}
            .map { itemViewModelFactory.fanart($0) }
            
        
        
        return [
            Section(id: "test", items: fanarts),
            Section(id: "misc", items:[
            itemViewModelFactory.castCarousel(for: show) {
                routes.accept(routeFactory.personDetailRoute(for: $0))
            },
            itemViewModelFactory.relatedShowsCarousel(for: show) {
                routes.accept(routeFactory.showDetailRoute(for: $0))
            },
        ])]
    }
    
    func selectItem(at indexPath: IndexPath) {
    
    }        
}
