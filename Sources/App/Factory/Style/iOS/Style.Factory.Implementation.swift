//
//  StyleFactory.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Model
import RxSwift
import Tabman
import UIKit

typealias StyleFactoryAlias = StyleFactoryImplementation

class StyleFactoryImplementation: DefaultStyleFactory {
    let container: Container<Style> = Container()

    static var factory: StyleFactory {
        (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).initializationRoot.styleFactory
    }

    func apply(_ style: Style, to view: PagerButton) {
        guard let implementation: TextStyle = getStyle(style) else { return }
        view.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        let color = implementation.style.attributes[.foregroundColor] as? UIColor
        view.tintColor = color?.withAlphaComponent(0.75)
        view.font = implementation.style.attributes[.font] as? UIFont ?? view.font
        //            button.font = Fonts.special(.regular).font(size: 20)
        //            button.font = Fonts.main(.bold).font(size: 16)
        view.selectedTintColor = color
    }

    let useCase: ThemeUseCase
    let disposeBag = DisposeBag()
    let root: RootContainer
    init(useCase: ThemeUseCase, root: RootContainer) {
        self.useCase = useCase
        self.root = root
        let themes: [Theme] = [DarkTheme(container: container),
                               LightTheme(container: container)]

        useCase.updateThemes(themes)

        useCase.currentTheme()
            .subscribe(onNext: { $0.setup() })
            .disposed(by: disposeBag)
    }
}
