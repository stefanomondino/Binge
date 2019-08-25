//
//  Scenes.swift
//  ViewModel
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

public extension Identifiers {
    enum Views: String, CaseIterable, Hashable, DependencyKey {
        case carousel
        case textPicker
        case show
		case loadMore
		case showPoster
		//MURRAY PLACEHOLDER
    }
}
