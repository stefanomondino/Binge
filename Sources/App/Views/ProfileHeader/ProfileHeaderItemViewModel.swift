import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class ProfileHeaderItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    let uniqueIdentifier: UniqueIdentifier
    let title: String

    init(profile: User,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.profileHeader) {
        self.layoutIdentifier = layoutIdentifier
        uniqueIdentifier = UUID()
        title = "@" + profile.username
    }
}
