//
//  CoreSceneFactory.swift
//  Core
//
//  Created by Stefano Mondino on 03/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import UIKit

public protocol CoreSceneFactory {
    func home() -> Scene
    func root() -> Scene
}
