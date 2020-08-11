//
//  PersonViewModel.swift
//  App
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class PersonItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier { person.uniqueIdentifier }
    let person: Person
    let image: ObservableImage

    var title: String {
        return person.name
    }

    init(person: Person,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.person,
         imagesUseCase: ImagesUseCase) {
        self.layoutIdentifier = layoutIdentifier

        self.person = person

        image = imagesUseCase
            .image(forPerson: person)
            .flatMapLatest { $0.getImage() }
            .share(replay: 1, scope: .forever)
    }
}
