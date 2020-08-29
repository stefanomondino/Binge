//
//  SplashUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol ThemeUseCase {
    func themes() -> Observable<[Theme]>
    func currentTheme() -> Observable<Theme>
    func changeCurrentTheme(_ theme: Theme)
    func updateThemes(_ themes: [Theme])
}
