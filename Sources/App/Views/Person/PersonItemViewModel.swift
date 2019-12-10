//
//  PersonViewModel.swift
//  App
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxRelay

class PersonItemViewModel: ViewModel {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier { person.uniqueIdentifier }
    let person: Person
    let image: ObservableImage
    let styleFactory: StyleFactory
    
    var title: String {
        return person.name
    }
    
    init(person: Person,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.person,
         imagesUseCase: ImagesUseCase,
         styleFactory: StyleFactory) {
         
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        
        self.person = person
        
        self.image = imagesUseCase
            .image(forPerson: person)
            .flatMapLatest { $0.getImage() }
            .share(replay:1, scope: .forever)
    }
}
