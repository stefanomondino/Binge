//
//  Routes.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang

public struct RestartRoute: ViewModelRoute {
    public let viewModel: SceneViewModelType
    public init() {
        self.viewModel = SplashViewModel()
    }
    init(viewModel: SceneViewModelType) {
        self.viewModel = viewModel
    }
}

public struct NavigationRoute: ViewModelRoute {
    public let viewModel: SceneViewModelType
}

public struct LoginRoute: ViewModelRoute {
    public let viewModel: SceneViewModelType = LoginViewModel()
    public init() {}
}

public struct ExitRoute: Route {
    public var destination: Scene? { return nil }
}

public struct ImagePickerSelectionRoute: Route {
    public var destination: Scene? { return nil }
    public let cameraAction: () -> Void
    public let libraryAction: () -> Void
}

public struct SystemImagePickerRoute: Route {
    public var destination: Scene? { return nil }
    public var viewModel: SystemImagePickerViewModel
}
public struct ErrorRoute: Route {
    public var destination: Scene?
    public let error: Error
    init(error: Error) {
        self.error = error
    }
}
