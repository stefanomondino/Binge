//
//  ViewModel.Container.swift
//  Skeleton
//
//  Created by Stefano Mondino on 03/07/2020.
//

import Boomerang
import Foundation

protocol ViewModelContainer {
    var items: ItemViewModelFactory { get }
    var scenes: SceneViewModelFactory { get }
    var pickers: PickerViewModelFactory { get }
}

private class ViewModelContainerImplementation: ViewModelContainer, DependencyContainer {
    enum Keys: String, CaseIterable, Hashable {
        case items
        case scenes
        case pickers
    }

    var items: ItemViewModelFactory { self[.items] }
    var pickers: PickerViewModelFactory { self[.pickers] }
    var scenes: SceneViewModelFactory { self[.scenes] }
    let container: Container<Keys> = Container()

    init(container: RootContainer) {
        register(for: .scenes) { DefaultSceneViewModelFactory(container: container) }
        register(for: .items) { DefaultItemViewModelFactory(container: container) }
        register(for: .pickers) { DefaultPickerViewModelFactory(container: container) }
    }
}

extension InitializationRoot {
    func viewModelImplementation() -> ViewModelContainer {
        ViewModelContainerImplementation(container: self)
    }
}
