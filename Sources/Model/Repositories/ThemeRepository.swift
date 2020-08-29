//
//  AuthorizationRepository.swift
//  Model
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol ThemeRepository {
    var themes: [Theme] { get }
    func updateThemes(_ themes: [Theme])
    func changeCurrentTheme(_ theme: Theme)
    var currentTheme: Observable<Theme> { get }
}

class DefaultThemeRepository: ThemeRepository {
    private let currentThemeId: BehaviorRelay<String>
    private struct EmptyTheme: Theme {
        var name: String = "Empty"
        var identifier: String = ""
        func setup() {}
    }

    private let properties: UserPropertyDataSource
    var themes: [Theme] = [EmptyTheme()]

    var currentTheme: Observable<Theme> {
        currentThemeId.asObservable().map { id in self.themes.first(where: { id == $0.identifier }) ?? self.defaultTheme }
    }

    private var defaultTheme: Theme {
        themes.first ?? EmptyTheme()
    }

    init(properties: UserPropertyDataSource) {
        self.properties = properties
        currentThemeId = BehaviorRelay(value: properties.selectedThemeId)
    }

    func updateThemes(_ themes: [Theme]) {
        self.themes = themes
        guard themes.first(where: { $0.identifier == self.currentThemeId.value }) != nil else {
            updateThemeId(themes.first?.identifier ?? defaultTheme.identifier)
            return
        }
    }

    func updateThemeId(_ id: String) {
        if properties.selectedThemeId != id || currentThemeId.value != id {
            properties.selectedThemeId = id
            currentThemeId.accept(id)
        }
    }

    func changeCurrentTheme(_ theme: Theme) {
        updateThemeId(theme.identifier)
    }
}
