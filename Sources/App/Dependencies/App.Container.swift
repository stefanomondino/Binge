//
//  App.Container.swift
//  Skeleton
//
//  Created by Stefano Mondino on 03/07/2020.
//

import Boomerang
import Foundation

protocol ViewContainer {
    var views: ViewFactory { get }
    var collectionCells: CollectionViewCellFactory { get }
    var scenes: ViewControllerFactory { get }
}

private class ViewContainerImplementation: ViewContainer, DependencyContainer {
    enum Keys: String, CaseIterable, Hashable {
        case views
        case scenes
        case collectionCells
    }

    var views: ViewFactory { self[.views] }
    var collectionCells: CollectionViewCellFactory { self[.collectionCells] }
    var scenes: ViewControllerFactory { self[.scenes] }
    let container: Container<Keys> = Container()

    init(container: RootContainer) {
        register(for: .views) { MainViewFactory(styleFactory: container.styleFactory) }
        register(for: .collectionCells) { MainCollectionViewCellFactory(viewFactory: self.views) }
        register(for: .scenes) { DefaultViewControllerFactory(container: container) }
    }
}

extension InitializationRoot {
    func viewImplementation() -> ViewContainer {
        ViewContainerImplementation(container: self)
    }
}
