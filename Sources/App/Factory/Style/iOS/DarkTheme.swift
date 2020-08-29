//
//  DarkTheme.swift
//  BingeTests_iOS
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Boomerang
import Foundation
import Model

class DarkTheme: Theme, DependencyContainer {
    let container: Container<Style>
    var name: String { "Dark" }
    var identifier: String { "themes.dark" }

    init(container: Container<Style>) {
        self.container = container
    }

    func setup() {
        register(for: .clear) { DefaultContainerStyle(backgroundColor: .clear) }
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

        register(for: .searchField) { [DefaultContainerStyle(cornerRadius: 4, backgroundColor: .navbarText),
                                       DefaultTextStyle(size: 16, color: .navbarBackground, font: .mainRegular, alignment: .left)] }

        register(for: .navigationBar) { [DefaultContainerStyle(backgroundColor: .navbarBackground),
                                         DefaultTextStyle(size: 22, color: .navbarText, font: .mainBold, alignment: .center)] }
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
}
