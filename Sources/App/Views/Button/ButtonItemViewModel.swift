import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

struct ButtonContents {
    let title: String
    let action: () -> Void
}

class ButtonItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    let uniqueIdentifier: UniqueIdentifier
    let title: String
    let action: () -> Void
    init(contents: ButtonContents,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.button) {
        self.layoutIdentifier = layoutIdentifier
        uniqueIdentifier = UUID()
        title = contents.title
        action = contents.action
    }
}
