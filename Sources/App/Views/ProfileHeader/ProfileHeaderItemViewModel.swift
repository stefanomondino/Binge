import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

class ProfileHeaderItemViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    let uniqueIdentifier: UniqueIdentifier
    let title: String
    let subtitle: String
    let image: ObservableImage

    init(profile: User,
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.profileHeader) {
        self.layoutIdentifier = layoutIdentifier
        uniqueIdentifier = UUID()
        title = "@" + profile.username
        subtitle = profile.name
        let mainImage: WithImage = profile.profileURL ?? Asset.user.image
        image = mainImage.getImage(with: Asset.user.image)
    }
}
