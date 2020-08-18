//
//  StyleFactory.swift
//  App
//
//  Created by Stefano Mondino on 22/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Tabman
import UIKit

typealias StyleFactoryAlias = StyleFactoryImplementation

class StyleFactoryImplementation: DefaultStyleFactory {
    var container: Container<Style> = Container()
    static var factory: StyleFactory {
        (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).initializationRoot.styleFactory
    }

    init(container _: RootContainer) {
        register(for: .container) { DefaultContainerStyle() }
        register(for: .title) { DefaultTextStyle(size: 18) }
        register(for: .subtitle) {
            ComposedTextStyle(base: DefaultTextStyle(size: 12,
                                                     color: .mainText,
                                                     font: Fonts.mainRegular, alignment: .left),
                              tags: (tag: .bold, style: DefaultTextStyle(size: 12,
                                                                         color: .mainText,
                                                                         font: Fonts.mainBold,
                                                                         alignment: .left)))
        }
        register(for: .carouselTitle) { DefaultTextStyle(size: 14, font: .mainBold, alignment: .left) }
        register(for: .navigationBar) { [DefaultContainerStyle(backgroundColor: .navbarBackground),
                                         DefaultTextStyle(size: 22, color: .navbarText, font: .mainBold)] }
        setupShows()
    }

    private func setupShows() {
        register(for: .titleCard) { [DefaultContainerStyle(cornerRadius: 4, backgroundColor: .clear),
                                     DefaultTextStyle(size: 22, color: .navbarText, font: Fonts.mainBold, alignment: .left)] }

        register(for: .itemTitle) { DefaultTextStyle(size: 10, color: .mainText, font: Fonts.mainBold, alignment: .center) }

        register(for: .itemSubtitle) { DefaultTextStyle(size: 10, color: .mainText, font: Fonts.mainRegular, alignment: .center) }

        register(for: .card) { [DefaultContainerStyle.card, self[.itemTitle] as TextStyle] }

        register(for: .episodeTitle) {
            ComposedTextStyle(base: DefaultTextStyle(size: 10, color: .mainText, font: Fonts.mainRegular, alignment: .left),
                              tags: (tag: .bold, style: DefaultTextStyle(size: 10, color: .mainText, font: Fonts.mainBold, alignment: .left)))
        }
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
}
