//
//
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation

public protocol DownloadableImage {
    var aspectRatio: Double { get }
    var uniqueIdentifier: String { get }
    var defaultImage: String? { get }
    var allowedSizes: KeyPath<TMDB.Image, [String]> { get }
}
