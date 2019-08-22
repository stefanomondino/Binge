//
//
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol Show: EntityType {
    var name: String { get }
    func poster(size: CGSize) -> WithImage
}
