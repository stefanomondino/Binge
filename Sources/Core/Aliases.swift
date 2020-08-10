//
//  Aliases.swift
//  Model
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
    public typealias Image = NSImage
    public typealias Color = NSColor
#else
    import UIKit
    public typealias Color = UIColor
    public typealias Image = UIImage
#endif
