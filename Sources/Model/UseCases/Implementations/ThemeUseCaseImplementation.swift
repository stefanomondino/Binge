//
//  SplashUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

struct ThemeUseCaseImplementation: ThemeUseCase {
    let repository: ThemeRepository
    init(repository: ThemeRepository) {
        self.repository = repository
    }

    func themes() -> Observable<[Theme]> {
        .just(repository.themes)
    }

    func updateThemes(_ themes: [Theme]) {
        repository.updateThemes(themes)
    }

    func currentTheme() -> Observable<Theme> {
        repository.currentTheme
    }

    func changeCurrentTheme(_ theme: Theme) {
        repository.changeCurrentTheme(theme)
    }
}
