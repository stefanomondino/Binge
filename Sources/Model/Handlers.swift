//
//  Handlers.swift
//  Model
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public class DefaultHandlers: Handlers {
    let container: ModelDependencyContainer
    init(container: ModelDependencyContainer) {
        self.container = container
    }
    public func onExternalURL(_ url: URL) {
        container.repositories.authorization.onAuthorizationURL(url: url)
    }
}
